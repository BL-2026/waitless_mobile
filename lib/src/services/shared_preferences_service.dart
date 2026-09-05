import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waitless_mobile/src/domain/entities/my_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _userKey = 'user';
  static const String _cartKey = 'shopping_cart';

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

  static Future<List<Map<String, dynamic>>> getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString(_cartKey);
    if (cartJson != null) {
      final List<dynamic> cartList = jsonDecode(cartJson);
      return cartList.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  static Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(cart);
    await prefs.setString(_cartKey, cartJson);
  }

  static Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
