import 'package:waitless_mobile/src/utils/typedef.dart';

abstract class AuthRepository {
  ResultFuture<void> signUp(String phoneNumber, String email, String password);
  ResultFuture<void> signIn(String email, String password);
  ResultFuture<void> forgotPassword(String email);
  ResultFuture<void> logout();
}
