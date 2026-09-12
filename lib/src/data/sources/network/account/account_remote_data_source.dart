import 'package:waitless_mobile/src/domain/entities/account.dart';

abstract class AccountRemoteDataSource {
  /// Creates the owner account in the backend. Idempotent on the Firebase UID:
  /// the server returns the existing row untouched when it already exists.
  Future<Account> createAccount(CreateAccountRequest request);

  Future<Account> currentAccount();
}
