import 'package:waitless_mobile/src/domain/entities/service_request.dart';

List<ServiceRequest> applyServiceRequestEvent(
  List<ServiceRequest> current,
  String event,
  ServiceRequest request,
) {
  switch (event) {
    case 'CREATED':
      if (current.any((r) => r.id == request.id)) return current;
      return [...current, request]
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    case 'ACKNOWLEDGED':
      return [
        for (final r in current)
          if (r.id == request.id) request else r,
      ];
    case 'RESOLVED':
      return current.where((r) => r.id != request.id).toList();
    default:
      return current;
  }
}

String storeRequestsTopic(String storeId) => '/topic/stores/$storeId/requests';
