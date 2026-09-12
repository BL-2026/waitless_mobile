import 'package:waitless_mobile/src/data/sources/network/api_client.dart';
import 'package:waitless_mobile/src/domain/entities/store.dart';

abstract class StoreRemoteDataSource {
  Future<List<Store>> listStores();
}

class StoreApiRemoteDataSourceImpl implements StoreRemoteDataSource {
  const StoreApiRemoteDataSourceImpl(this._client);

  final WaitlessApiClient _client;

  @override
  Future<List<Store>> listStores() async {
    final body = await _client.get('/api/stores') as List<dynamic>;
    return body
        .map((json) => Store.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
