import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';
import 'package:waitless_mobile/src/domain/usecases/request_usecases.dart';

class RequestsState {
  final List<ServiceRequest> requests;
  final bool loading;

  const RequestsState({required this.requests, required this.loading});

  factory RequestsState.initial() =>
      const RequestsState(requests: [], loading: true);

  RequestsState copyWith({List<ServiceRequest>? requests, bool? loading}) {
    return RequestsState(
      requests: requests ?? this.requests,
      loading: loading ?? this.loading,
    );
  }
}

/// A Cubit is a simpler cousin of Bloc — no events, just methods you
/// call directly (cubit.acknowledge('r1')) that produce a new state.
/// Matches the pattern your auth cubits already use.
class RequestsCubit extends Cubit<RequestsState> {
  final WatchActiveRequestsUseCase _watchActiveRequests;
  final AcknowledgeRequestUseCase _acknowledgeRequest;
  final ResolveRequestUseCase _resolveRequest;

  StreamSubscription<List<ServiceRequest>>? _subscription;

  RequestsCubit({
    required this._watchActiveRequests,
    required this._acknowledgeRequest,
    required this._resolveRequest,
  })  : super(RequestsState.initial()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription = _watchActiveRequests().listen((requests) {
      emit(state.copyWith(requests: requests, loading: false));
    });
  }

  Future<void> acknowledge(String requestId) => _acknowledgeRequest(requestId);

  Future<void> resolve(String requestId) => _resolveRequest(requestId);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
