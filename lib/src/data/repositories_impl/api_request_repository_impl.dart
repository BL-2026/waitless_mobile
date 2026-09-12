import 'dart:async';

import 'package:waitless_mobile/src/data/sources/network/request/request_remote_data_source.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';
import 'package:waitless_mobile/src/domain/repositories/request_repository.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/services/staff_session.dart';

/// Live queue backed by the real API. The backend also broadcasts over STOMP at
/// `/topic/stores/{storeId}/requests`, but that handshake is still unauthenticated,
/// so this polls instead — indistinguishable to the floor team at a few seconds.
class ApiRequestRepositoryImpl implements RequestRepository {
  ApiRequestRepositoryImpl(this._dataSource, this._session);

  final RequestRemoteDataSource _dataSource;
  final StaffSession _session;

  static const pollInterval = Duration(seconds: 3);

  Future<void> Function()? _refresh;

  @override
  Stream<List<ServiceRequest>> watchActiveRequests() {
    late final StreamController<List<ServiceRequest>> controller;
    Timer? timer;
    var inFlight = false;

    Future<void> poll() async {
      // A slow response must not let ticks pile up on top of each other.
      if (inFlight || controller.isClosed) return;
      inFlight = true;
      try {
        final requests = await _dataSource.listActive(_session.requireStoreId());
        if (!controller.isClosed) controller.add(requests);
      } on Failure catch (e) {
        // Surface the blip but keep the timer alive so the next tick can recover.
        if (!controller.isClosed) controller.addError(e);
      } finally {
        inFlight = false;
      }
    }

    controller = StreamController<List<ServiceRequest>>(
      onListen: () {
        _refresh = poll;
        poll();
        timer = Timer.periodic(pollInterval, (_) => poll());
      },
      onCancel: () {
        timer?.cancel();
        _refresh = null;
        return controller.close();
      },
    );

    return controller.stream;
  }

  @override
  Future<void> acknowledge(String requestId) async {
    await _dataSource.acknowledge(requestId, _session.requireStaffId());
    // Don't make the waitress wait up to a full poll to see her own tap land.
    await _refresh?.call();
  }

  @override
  Future<void> resolve(String requestId) async {
    await _dataSource.resolve(requestId);
    await _refresh?.call();
  }
}
