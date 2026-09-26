import 'package:waitless_mobile/src/data/sources/network/api_client.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';

abstract class RequestRemoteDataSource {
  Future<List<ServiceRequest>> listActive(String storeId);
  Future<void> acknowledge(String requestId, String staffId);
  Future<void> resolve(String requestId);
}

class RequestApiRemoteDataSourceImpl implements RequestRemoteDataSource {
  const RequestApiRemoteDataSourceImpl(this._client);

  final WaitlessApiClient _client;

  @override
  Future<List<ServiceRequest>> listActive(String storeId) async {
    final body =
        await _client.get('/api/stores/$storeId/requests/active') as List<dynamic>;
    return body
        .map((json) => ServiceRequest.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> acknowledge(String requestId, String staffId) async {
    await _client.post('/api/requests/$requestId/acknowledge', {'staffId': staffId});
  }

  @override
  Future<void> resolve(String requestId) async {
    await _client.post('/api/requests/$requestId/resolve');
  }
}
