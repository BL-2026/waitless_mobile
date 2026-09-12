import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waitless_mobile/src/domain/entities/my_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _userKey = 'user';
  static const String _languageKey = 'app_language';

  static Future<MyUser> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await addUserToSharedPreferences();
    String? user = prefs.getString(_userKey);
    final userMap = jsonDecode(user!);
    return MyUser.fromJson(userMap);
  }

  static Future<void> addUserToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final firebaseUser = FirebaseAuth.instance.currentUser;

    MyUser myUser = MyUser(
      uid: firebaseUser?.uid,
      email: firebaseUser?.email,
    );

    final encodedUser = jsonEncode(myUser.toJson());
    await prefs.setString(_userKey, encodedUser);
  }

  static Future<void> deleteUserFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  static Future<void> setLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, code);
  }
}
