import '../entities/service_request.dart';

abstract class RequestRepository {
  Stream<List<ServiceRequest>> watchActiveRequests();
  Future<void> acknowledge(String requestId);
  Future<void> resolve(String requestId);
}
