import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:waitless_mobile/src/exceptions/app_error_code.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/utils/constants/shared_variables.dart';
import 'package:waitless_mobile/src/utils/constants/urls.dart';

/// Thin wrapper over the Waitless backend: attaches the current Firebase ID token
/// to every call and turns the server's `ApiError` body into an [ApiFailure].
class WaitlessApiClient {
  const WaitlessApiClient(this._client, this._auth);

  final http.Client _client;
  final FirebaseAuth _auth;

  Future<dynamic> get(String path) async {
    return _send(() async =>
        _client.get(_uri(path), headers: await _headers()));
  }

  Future<dynamic> post(String path, [Object? body]) async {
    return _send(() async => _client.post(
          _uri(path),
          headers: await _headers(),
          body: body == null ? null : jsonEncode(body),
        ));
  }

  Future<dynamic> delete(String path, [Object? body]) async {
    return _send(() async => _client.delete(
          _uri(path),
          headers: await _headers(),
          body: body == null ? null : jsonEncode(body),
        ));
  }

  Uri _uri(String path) => Uri.parse('$waitlessApiBaseUrl$path');

  static const _timeout = Duration(seconds: timeOut);

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      // Socket errors, DNS failures, timeouts, backend not reachable from this device.
      throw ApiFailure(
        message: e.toString(),
        statusCode: '0',
        code: AppErrorCode.networkUnreachable,
      );
    }
    return _decode(response);
  }

  Future<Map<String, String>> _headers() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ApiFailure(
        message: 'Not signed in',
        statusCode: '401',
        code: AppErrorCode.authSessionMissing,
      );
    }
    final token = await user.getIdToken().timeout(_timeout);
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Returns the decoded body — a `Map` for objects, a `List` for collections.
  dynamic _decode(http.Response response) {
    final body = utf8.decode(response.bodyBytes);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body.isEmpty ? null : jsonDecode(body);
    }

    String message = response.reasonPhrase ?? 'Request failed';
    String? code;
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      message = json['message']?.toString() ?? message;
      code = json['code']?.toString();
    } on FormatException {
      // Non-JSON error body; status alone is enough for localization.
    }

    throw ApiFailure(
      message: message,
      statusCode: '${response.statusCode}',
      code: code,
    );
  }
}
