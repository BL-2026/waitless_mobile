import 'request_status.dart';
import 'request_type.dart';

/// A single call from a table — "call waiter" or "request bill".
/// This class knows nothing about the network or the UI; it's the
/// same shape whether the data came from a mock, a WebSocket, or REST.
class ServiceRequest {
  final String id;
  final int tableNumber;
  final RequestType type;
  final RequestStatus status;
  final DateTime createdAt;
  final String? paymentMethod; // only set when type == requestBill

  const ServiceRequest({
    required this.id,
    required this.tableNumber,
    required this.type,
    required this.status,
    required this.createdAt,
    this.paymentMethod,
  });

  /// copyWith lets the cubit produce a new ServiceRequest with one
  /// field changed (e.g. status) without mutating the original —
  /// entities in clean architecture are treated as immutable.
  ServiceRequest copyWith({RequestStatus? status}) {
    return ServiceRequest(
      id: id,
      tableNumber: tableNumber,
      type: type,
      status: status ?? this.status,
      createdAt: createdAt,
      paymentMethod: paymentMethod,
    );
  }
}
