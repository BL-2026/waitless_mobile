import '../entities/service_request.dart';

/// The domain layer only knows THIS interface — not whether requests
/// come from a mock list, a WebSocket, or REST polling. That's decided
/// entirely inside data/repositories_impl.
abstract class RequestRepository {
  /// A Stream, not a Future, because new requests can arrive at any
  /// time — this is what makes the queue feel "live".
  Stream<List<ServiceRequest>> watchActiveRequests();

  Future<void> acknowledge(String requestId);
  Future<void> resolve(String requestId);
}
