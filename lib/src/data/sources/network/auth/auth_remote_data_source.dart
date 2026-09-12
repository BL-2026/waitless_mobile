abstract class AuthRemoteDataSource {
  Future<void> signIn(String email, String password);

  /// Creates the Firebase identity only. The owner account itself lives in the
  /// backend — see [AccountRemoteDataSource].
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  /// Rolls back a half-finished sign-up so the e-mail is free to retry.
  Future<void> deleteCurrentUser();

  Future<void> forgotPassword(String email);
  Future<void> logout();
}
