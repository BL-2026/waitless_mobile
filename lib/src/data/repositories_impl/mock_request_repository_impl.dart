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
        tableNumber: 12,
        zone: 'terrace',
        type: RequestType.callWaiter,
        status: RequestStatus.open,
        createdAt: now.subtract(const Duration(seconds: 18)),
      ),
      ServiceRequest(
        id: 'r2',
        tableNumber: 4,
        zone: 'salon',
        type: RequestType.requestBill,
        status: RequestStatus.acknowledged,
        createdAt: now.subtract(const Duration(minutes: 2)),
        paymentMethod: 'card',
      ),
      ServiceRequest(
        id: 'r3',
        tableNumber: 21,
        zone: 'patio',
        type: RequestType.callWaiter,
        status: RequestStatus.open,
        createdAt: now.subtract(const Duration(minutes: 4)),
      ),
      ServiceRequest(
        id: 'r4',
        tableNumber: 8,
        zone: 'lounge',
        type: RequestType.requestBill,
        status: RequestStatus.open,
        createdAt: now.subtract(const Duration(seconds: 40)),
        paymentMethod: 'cash',
      ),
    ]);
  }

  void _emit() {
    final active = _requests
        .where((r) => r.status != RequestStatus.resolved)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _controller.add(active);
  }

  void _simulateIncomingRequest() {
    Timer(const Duration(seconds: 8), () {
      _requests.add(
        ServiceRequest(
          id: 'r5',
          tableNumber: 16,
          zone: 'terrace',
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
