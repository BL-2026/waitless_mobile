import 'dart:async';
import 'package:waitless_mobile/src/domain/repositories/request_repository.dart';

import '../../domain/entities/request_status.dart';
import '../../domain/entities/request_type.dart';
import '../../domain/entities/service_request.dart';

class MockRequestRepositoryImpl implements RequestRepository {
  final _controller = StreamController<List<ServiceRequest>>.broadcast();
  final List<ServiceRequest> _requests = [];

  MockRequestRepositoryImpl() {
    _seed();
    _emit();
    _simulateIncomingRequest();
  }

  void _seed() {
    final now = DateTime.now();
    _requests.addAll([
      ServiceRequest(
        id: 'r1',
        tableNumber: 7,
        type: RequestType.callWaiter,
        status: RequestStatus.open,
        createdAt: now.subtract(const Duration(seconds: 5)),
      ),
      ServiceRequest(
        id: 'r2',
        tableNumber: 3,
        type: RequestType.requestBill,
        status: RequestStatus.acknowledged,
        createdAt: now.subtract(const Duration(minutes: 2)),
        paymentMethod: 'card',
      ),
    ]);
  }

  void _emit() {
    // Only "open" and "acknowledged" requests belong in the active queue —
    // resolved ones move to history (a separate use case/page later).
    final active = _requests
        .where((r) => r.status != RequestStatus.resolved)
        .toList();
    _controller.add(active);
  }

  /// Fakes a new table call arriving after a delay, so the queue screen
  /// has something to react to without a real backend running.
  void _simulateIncomingRequest() {
    Timer(const Duration(seconds: 8), () {
      _requests.add(
        ServiceRequest(
          id: 'r3',
          tableNumber: 5,
          type: RequestType.callWaiter,
          status: RequestStatus.open,
          createdAt: DateTime.now(),
        ),
      );
      _emit();
    });
  }

  @override
  Stream<List<ServiceRequest>> watchActiveRequests() => _controller.stream;

  @override
  Future<void> acknowledge(String requestId) async {
    _updateStatus(requestId, RequestStatus.acknowledged);
  }

  @override
  Future<void> resolve(String requestId) async {
    _updateStatus(requestId, RequestStatus.resolved);
  }

  void _updateStatus(String requestId, RequestStatus status) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;
    _requests[index] = _requests[index].copyWith(status: status);
    _emit();
  }

  void dispose() => _controller.close();
}
