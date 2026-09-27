import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waitless_mobile/src/exceptions/user_already_exists.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_remote_data_source.dart';
import 'package:waitless_mobile/src/exceptions/app_error_code.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/exceptions/sign_in_cancelled.dart';
import 'package:waitless_mobile/src/exceptions/user_not_found.dart';
import 'package:waitless_mobile/src/services/shared_preferences_service.dart';
import 'package:waitless_mobile/src/utils/helpers/firebase_failure.dart';

class AuthFirebaseRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthFirebaseRemoteDataSourceImpl(this._auth, this._googleSignIn);
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // The backend reads the name off the verified token when the body omits it,
      // so keep the Firebase profile in step with the Account row.
      await userCredential.user?.updateDisplayName(fullName);

      await SharedPreferencesService.addUserToSharedPreferences();
    } on ApiFailure {
      rethrow;
    } on UserAlreadyExists catch (e) {
      throw ApiFailure(
        message: e.message,
        statusCode: e.statusCode,
        code: AppErrorCode.authEmailInUse,
      );
    } on FirebaseException catch (e) {
      throw failureFromFirebase(
        firebaseCode: e.code,
        message: e.message,
        fallbackCode: AppErrorCode.unknown,
      );
    }
  }

  @override
  Future<void> deleteCurrentUser() async {
    try {
      await _auth.currentUser?.delete();
      await SharedPreferencesService.deleteUserFromSharedPreferences();
    } on FirebaseException catch (e) {
      throw failureFromFirebase(firebaseCode: e.code, message: e.message);
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      await SharedPreferencesService.addUserToSharedPreferences();
    } on FirebaseException catch (e) {
      final failure = failureFromFirebase(
        firebaseCode: e.code,
        message: e.message,
        fallbackCode: AppErrorCode.authInvalidCredentials,
      );
      throw UserNotFound(
        message: failure.message,
        statusCode: failure.statusCode,
        code: failure.code,
      );
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const SignInCancelled();
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      await SharedPreferencesService.addUserToSharedPreferences();
    } on SignInCancelled {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw failureFromFirebase(
        firebaseCode: e.code,
        message: e.message,
        fallbackCode: AppErrorCode.authGoogleFailed,
      );
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled' || e.code == 'sign_in_cancelled') {
        throw const SignInCancelled();
      }
      throw ApiFailure(
        message: e.message ?? e.code,
        statusCode: e.code,
        code: AppErrorCode.authGoogleFailed,
      );
    } on FirebaseException catch (e) {
      throw failureFromFirebase(
        firebaseCode: e.code,
        message: e.message,
        fallbackCode: AppErrorCode.authGoogleFailed,
      );
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      final failure = failureFromFirebase(
        firebaseCode: e.code,
        message: e.message,
        fallbackCode: AppErrorCode.authResetFailed,
      );
      throw UserNotFound(
        message: failure.message,
        statusCode: failure.statusCode,
        code: failure.code,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await SharedPreferencesService.deleteUserFromSharedPreferences();
    } catch (e) {
      throw ApiFailure(
        message: e.toString(),
        statusCode: '505',
        code: AppErrorCode.authLogoutFailed,
      );
    }
  }
}
