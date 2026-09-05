import 'request_status.dart';
import 'request_type.dart';

class ServiceRequest {
  final String id;
  final int tableNumber;
  final String zone;
  final RequestType type;
  final RequestStatus status;
  final DateTime createdAt;
  final String? paymentMethod;

  const ServiceRequest({
    required this.id,
    required this.tableNumber,
    required this.zone,
    required this.type,
    required this.status,
    required this.createdAt,
    this.paymentMethod,
  });

  ServiceRequest copyWith({RequestStatus? status}) {
    return ServiceRequest(
      id: id,
      tableNumber: tableNumber,
      zone: zone,
      type: type,
      status: status ?? this.status,
      createdAt: createdAt,
      paymentMethod: paymentMethod,
    );
  }
}
