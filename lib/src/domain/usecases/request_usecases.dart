import 'package:waitless_mobile/src/domain/repositories/request_repository.dart';

import '../entities/service_request.dart';

class WatchActiveRequestsUseCase {
  final RequestRepository repository;
  WatchActiveRequestsUseCase(this.repository);

  Stream<List<ServiceRequest>> call() => repository.watchActiveRequests();
}

class AcknowledgeRequestUseCase {
  final RequestRepository repository;
  AcknowledgeRequestUseCase(this.repository);

  Future<void> call(String requestId) => repository.acknowledge(requestId);
}

class ResolveRequestUseCase {
  final RequestRepository repository;
  ResolveRequestUseCase(this.repository);

  Future<void> call(String requestId) => repository.resolve(requestId);
}
