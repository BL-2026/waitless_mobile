import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';
import 'package:waitless_mobile/src/domain/usecases/request_usecases.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';

class RequestsState {
  final List<ServiceRequest> requests;
  final bool loading;

  /// Set when the last poll failed. The queue keeps the requests it already has
  /// so a dropped connection doesn't blank the screen mid-service.
  final String? error;

  /// Requests the latest poll found that the one before it didn't. Like [error]
  /// this resets on every new state rather than carrying forward, so the alert
  /// fires once for an arrival instead of again on the next tick.
  final List<ServiceRequest> arrivals;

  const RequestsState({
    required this.requests,
    required this.loading,
    this.error,
    this.arrivals = const [],
  });

  factory RequestsState.initial() =>
      const RequestsState(requests: [], loading: true);

  RequestsState copyWith({
    List<ServiceRequest>? requests,
    bool? loading,
    String? error,
    List<ServiceRequest>? arrivals,
  }) {
    return RequestsState(
      requests: requests ?? this.requests,
      loading: loading ?? this.loading,
      error: error,
      arrivals: arrivals ?? const [],
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

  /// Ids seen in the previous poll, so the next one can tell an arrival from a
  /// request that's simply still waiting. Resolving is terminal on the backend, so
  /// a request that drops off the active list never returns and this stays small.
  Set<String> _knownIds = {};

  /// False until the first poll lands. See [_onRequests].
  bool _seeded = false;

  RequestsCubit({
    required this._watchActiveRequests,
    required this._acknowledgeRequest,
    required this._resolveRequest,
  }) : super(RequestsState.initial()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription = _watchActiveRequests().listen(
      _onRequests,
      onError: (Object e) => emit(
        state.copyWith(
          loading: false,
          error: e is Failure ? e.message : e.toString(),
        ),
      ),
    );
  }

  void _onRequests(List<ServiceRequest> requests) {
    // The first poll is the backlog that was already waiting, not news: unlocking
    // the app shouldn't buzz once per request that's sitting on screen anyway.
    final arrivals = _seeded
        ? requests.where((r) => !_knownIds.contains(r.id)).toList()
        : const <ServiceRequest>[];

    _knownIds = requests.map((r) => r.id).toSet();
    _seeded = true;

    emit(
      state.copyWith(requests: requests, loading: false, arrivals: arrivals),
    );
  }

  Future<void> acknowledge(String requestId) =>
      _run(() => _acknowledgeRequest(requestId));

  Future<void> resolve(String requestId) =>
      _run(() => _resolveRequest(requestId));

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } on Failure catch (e) {
      emit(state.copyWith(error: e.message));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
