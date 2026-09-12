import 'package:waitless_mobile/src/utils/typedef.dart';

abstract class AuthRepository {
  /// Creates the Firebase identity and the backend account together.
  /// [phoneArea] is the dial code (`+212`), [phoneNumber] the national part.
  ResultFuture<void> signUp({
    required String fullName,
    required String phoneArea,
    required String phoneNumber,
    required String email,
    required String password,
  });

  ResultFuture<void> signIn(String email, String password);
  ResultFuture<void> forgotPassword(String email);
  ResultFuture<void> logout();
}
