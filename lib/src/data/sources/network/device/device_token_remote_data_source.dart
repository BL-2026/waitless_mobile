import 'package:waitless_mobile/src/data/sources/network/api_client.dart';

class DeviceTokenRemoteDataSource {
  const DeviceTokenRemoteDataSource(this._client);

  final WaitlessApiClient _client;

  Future<void> register(String storeId, String token, String locale) async {
    await _client.post('/api/stores/$storeId/device-tokens', {
      'token': token,
      'locale': locale,
    });
  }

  Future<void> unregister(String storeId, String token) async {
    await _client.delete('/api/stores/$storeId/device-tokens', {
      'token': token,
    });
  }
}
