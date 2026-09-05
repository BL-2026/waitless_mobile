abstract class AuthRemoteDataSource {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String phoneNumber, String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> logout();
}
