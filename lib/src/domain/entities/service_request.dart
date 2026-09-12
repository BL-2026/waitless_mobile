import 'request_status.dart';
import 'request_type.dart';

/// Mirrors `ServiceRequestResponse` on the backend.
class ServiceRequest {
  final String id;
  final int tableNumber;

  /// Free-form area label. Null when the table has no zone assigned.
  final String? zone;
  final RequestType type;
  final RequestStatus status;
  final DateTime createdAt;

  /// `CARD` or `CASH`, only set when [type] is [RequestType.requestBill].
  final String? paymentMethod;
  final String? acknowledgedByName;

  const ServiceRequest({
    required this.id,
    required this.tableNumber,
    required this.type,
    required this.status,
    required this.createdAt,
    this.zone,
    this.paymentMethod,
    this.acknowledgedByName,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) => ServiceRequest(
        id: json['id'].toString(),
        tableNumber: (json['tableNumber'] as num).toInt(),
        zone: json['zone']?.toString(),
        type: RequestTypeX.fromApi(json['type'].toString()),
        status: RequestStatusX.fromApi(json['status'].toString()),
        createdAt: DateTime.parse(json['createdAt'].toString()).toLocal(),
        paymentMethod: json['paymentMethod']?.toString(),
        acknowledgedByName: json['acknowledgedByName']?.toString(),
      );

  ServiceRequest copyWith({RequestStatus? status}) {
    return ServiceRequest(
      id: id,
      tableNumber: tableNumber,
      zone: zone,
      type: type,
      status: status ?? this.status,
      createdAt: createdAt,
      paymentMethod: paymentMethod,
      acknowledgedByName: acknowledgedByName,
    );
  }
}
