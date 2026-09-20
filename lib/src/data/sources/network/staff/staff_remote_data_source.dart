import 'package:waitless_mobile/src/data/sources/network/api_client.dart';
import 'package:waitless_mobile/src/domain/entities/staff_member.dart';

abstract class StaffRemoteDataSource {
  Future<List<StaffMember>> listStaff(String storeId);

  Future<StaffMember?> verifyPin(String storeId, String pin);
}

class StaffApiRemoteDataSourceImpl implements StaffRemoteDataSource {
  const StaffApiRemoteDataSourceImpl(this._client);

  final WaitlessApiClient _client;

  @override
  Future<List<StaffMember>> listStaff(String storeId) async {
    final body = await _client.get('/api/stores/$storeId/staff') as List<dynamic>;
    return body
        .map((json) => StaffMember.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<StaffMember?> verifyPin(String storeId, String pin) async {
    final body =
        await _client.post('/api/stores/$storeId/verify-pin', {'pin': pin})
            as Map<String, dynamic>;

    if (body['valid'] != true) return null;
    return StaffMember(
      id: body['staffId'].toString(),
      fullName: body['fullName'].toString(),
    );
  }
}
