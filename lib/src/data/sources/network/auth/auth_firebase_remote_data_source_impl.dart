import 'package:waitless_mobile/src/exceptions/user_already_exists.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_remote_data_source.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/exceptions/user_not_found.dart';
import 'package:waitless_mobile/src/services/shared_preferences_service.dart';

class AuthFirebaseRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthFirebaseRemoteDataSourceImpl(this._auth);
  final FirebaseAuth _auth;

  static const firebaseException = 'FirebaseException';

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
    } on ApiFailure catch (e) {
      throw ApiFailure(message: e.message, statusCode: e.statusCode);
    } on UserAlreadyExists catch (e) {
      throw ApiFailure(message: e.message, statusCode: e.statusCode);
    } on FirebaseException catch (e) {
      throw ApiFailure(
          message: e.message ?? firebaseException, statusCode: e.code);
    }
  }

  @override
  Future<void> deleteCurrentUser() async {
    try {
      await _auth.currentUser?.delete();
      await SharedPreferencesService.deleteUserFromSharedPreferences();
    } on FirebaseException catch (e) {
      throw ApiFailure(
          message: e.message ?? firebaseException, statusCode: e.code);
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      await SharedPreferencesService.addUserToSharedPreferences();
    } on FirebaseException catch (e) {
      throw UserNotFound(
          message: e.message ?? firebaseException, statusCode: e.code);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      throw UserNotFound(
          message: e.message ?? firebaseException, statusCode: e.code);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await SharedPreferencesService.deleteUserFromSharedPreferences();
    } catch (e) {
      throw const ApiFailure(
          message: 'Something went wrong, please try again', statusCode: '505');
    }
  }
}
