import 'package:waitless_mobile/src/data/sources/network/account/account_remote_data_source.dart';
import 'package:waitless_mobile/src/data/sources/network/api_client.dart';
import 'package:waitless_mobile/src/domain/entities/account.dart';
import 'package:waitless_mobile/src/utils/constants/end_points.dart';

/// Talks to the Spring backend, which verifies the Firebase ID token attached by
/// [WaitlessApiClient] and resolves it to an `Account` row in Postgres.
class AccountApiRemoteDataSourceImpl implements AccountRemoteDataSource {
  const AccountApiRemoteDataSourceImpl(this._client);

  final WaitlessApiClient _client;

  @override
  Future<Account> createAccount(CreateAccountRequest request) async {
    final body = await _client.post(accountEndPoint, request.toJson());
    return Account.fromJson(body as Map<String, dynamic>);
  }

  @override
  Future<Account> currentAccount() async {
    final body = await _client.get(currentAccountEndPoint);
    return Account.fromJson(body as Map<String, dynamic>);
  }
}
