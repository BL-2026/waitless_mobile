import 'package:waitless_mobile/src/exceptions/user_already_exists.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_remote_data_source.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/exceptions/user_not_found.dart';
import 'package:waitless_mobile/src/services/shared_preferences_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthFirebaseRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthFirebaseRemoteDataSourceImpl(this._auth);
  final FirebaseAuth _auth;

  static const firebaseException = 'FirebaseException';
  
  @override
  Future<void> signUp(
      String phoneNumber, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password);

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'phoneNumber': phoneNumber,
        });
      }

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

  static Future<String?> getUserPersonIdByUID() async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    final uid = FirebaseAuth.instance.currentUser?.uid;

    String? personId;
    QuerySnapshot querySnapshot =
        await users.where('uid', isEqualTo: uid).get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      personId = doc["personId"].toString();
      break;
    }
    return personId;
  }

  static Future<String?> getPersonEmailByEmail(String userEmail) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    String? fetchedEmail;

    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: userEmail.toLowerCase()).get();

    if (querySnapshot.docs.isNotEmpty) {
      fetchedEmail = querySnapshot.docs.first['email'].toString();
    }

    return fetchedEmail;
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
