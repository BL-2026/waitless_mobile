import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:waitless_mobile/src/data/realtime/store_requests_realtime_client.dart';
import 'package:waitless_mobile/src/data/sources/network/request/request_remote_data_source.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';
import 'package:waitless_mobile/src/domain/repositories/request_repository.dart';
import 'package:waitless_mobile/src/exceptions/app_error_code.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/services/staff_session.dart';

class ApiRequestRepositoryImpl implements RequestRepository {
  ApiRequestRepositoryImpl(this._dataSource, this._session, this._auth);

  final RequestRemoteDataSource _dataSource;
  final StaffSession _session;
  final FirebaseAuth _auth;

  @override
  Stream<List<ServiceRequest>> watchActiveRequests() {
    late final StreamController<List<ServiceRequest>> controller;
    StoreRequestsRealtimeClient? client;

    controller = StreamController<List<ServiceRequest>>(
      onListen: () async {
        try {
          client = StoreRequestsRealtimeClient(
            dataSource: _dataSource,
            auth: _auth,
            storeId: _session.requireStoreId(),
            onQueue: (requests) {
              if (!controller.isClosed) controller.add(requests);
            },
            onError: (error) {
              if (!controller.isClosed) controller.addError(error);
            },
          );
          await client!.start();
        } on Failure catch (e) {
          if (!controller.isClosed) controller.addError(e);
        } catch (e) {
          if (!controller.isClosed) {
            controller.addError(ApiFailure(
              message: e.toString(),
              statusCode: '0',
              code: AppErrorCode.liveUpdatesDisconnected,
            ));
          }
        }
      },
      onCancel: () {
        client?.dispose();
        client = null;
        return controller.close();
      },
    );

    return controller.stream;
  }

  @override
  Future<void> acknowledge(String requestId) =>
      _dataSource.acknowledge(requestId, _session.requireStaffId());

  @override
  Future<void> resolve(String requestId) => _dataSource.resolve(requestId);
}
