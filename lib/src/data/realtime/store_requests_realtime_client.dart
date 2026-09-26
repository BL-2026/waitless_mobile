import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:waitless_mobile/src/data/realtime/active_requests_reducer.dart';
import 'package:waitless_mobile/src/data/sources/network/request/request_remote_data_source.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';
import 'package:waitless_mobile/src/exceptions/app_error_code.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/utils/constants/urls.dart';

/// Owns the STOMP session for one store: connect, subscribe, resync, reconnect.
///
/// Ordering matters. Subscribe first and buffer frames, then take a REST snapshot,
/// then replay the buffer. That way a request created between the snapshot and the
/// subscribe cannot vanish into a gap.
class StoreRequestsRealtimeClient {
  StoreRequestsRealtimeClient({
    required this._dataSource,
    required this._auth,
    required this.storeId,
    required this._onQueue,
    required this._onError,
  });

  final RequestRemoteDataSource _dataSource;
  final FirebaseAuth _auth;
  final String storeId;
  final void Function(List<ServiceRequest> requests) _onQueue;
  final void Function(Object error) _onError;

  StompClient? _client;
  List<ServiceRequest> _current = const [];
  final List<Map<String, dynamic>> _buffer = [];
  var _ready = false;
  var _disposed = false;

  Future<void> start() async {
    final connectHeaders = <String, String>{
      'Authorization': 'Bearer ${await _idToken()}',
    };

    _client = StompClient(
      config: StompConfig(
        url: waitlessWsUrl,
        stompConnectHeaders: connectHeaders,
        reconnectDelay: const Duration(seconds: 3),
        beforeConnect: () async {
          connectHeaders['Authorization'] = 'Bearer ${await _idToken()}';
        },
        onConnect: (_) => _onConnected(),
        onWebSocketError: (error) {
          if (!_disposed) {
            _onError(ApiFailure(
              message: error.toString(),
              statusCode: '0',
              code: AppErrorCode.liveUpdatesDisconnected,
            ));
          }
        },
        onStompError: (frame) {
          if (!_disposed) {
            _onError(ApiFailure(
              message: frame.body ?? 'Live updates rejected',
              statusCode: '401',
              code: AppErrorCode.liveUpdatesUnauthorized,
            ));
          }
        },
      ),
    );
    _client!.activate();
  }

  void dispose() {
    _disposed = true;
    _client?.deactivate();
    _client = null;
  }

  Future<void> _onConnected() async {
    _ready = false;
    _buffer.clear();

    _client?.subscribe(
      destination: storeRequestsTopic(storeId),
      callback: (frame) {
        final body = frame.body;
        if (body == null || body.isEmpty) return;
        try {
          final json = jsonDecode(body) as Map<String, dynamic>;
          if (_ready) {
            _apply(json);
          } else {
            _buffer.add(json);
          }
        } catch (_) {
          // Malformed frame — ignore; the next snapshot/event repairs state.
        }
      },
    );

    try {
      _current = await _dataSource.listActive(storeId);
      for (final event in _buffer) {
        _applyEventMap(event);
      }
      _buffer.clear();
      _ready = true;
      if (!_disposed) _onQueue(List.unmodifiable(_current));
    } on Failure catch (e) {
      if (!_disposed) _onError(e);
    } catch (e) {
      if (!_disposed) {
        _onError(ApiFailure(
          message: e.toString(),
          statusCode: '0',
          code: AppErrorCode.liveSyncFailed,
        ));
      }
    }
  }

  void _apply(Map<String, dynamic> body) {
    _applyEventMap(body);
    if (!_disposed) _onQueue(List.unmodifiable(_current));
  }

  void _applyEventMap(Map<String, dynamic> body) {
    final event = body['event']?.toString();
    final raw = body['request'];
    if (event == null || raw is! Map<String, dynamic>) return;
    _current = applyServiceRequestEvent(
      _current,
      event,
      ServiceRequest.fromJson(raw),
    );
  }

  Future<String> _idToken() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ApiFailure(
        message: 'Not signed in',
        statusCode: '401',
        code: AppErrorCode.authSessionMissing,
      );
    }
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw const ApiFailure(
        message: 'Not signed in',
        statusCode: '401',
        code: AppErrorCode.authSessionMissing,
      );
    }
    return token;
  }
}
