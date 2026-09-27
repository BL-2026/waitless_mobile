import 'package:waitless_mobile/src/exceptions/app_error_code.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';

/// Maps a Firebase Auth exception onto [ApiFailure] so the UI can localize it.
ApiFailure failureFromFirebase({
  required String firebaseCode,
  String? message,
  String fallbackCode = AppErrorCode.unknown,
}) {
  return ApiFailure(
    message: message ?? firebaseCode,
    statusCode: firebaseCode,
    code: _codeFor(firebaseCode) ?? fallbackCode,
  );
}

String? _codeFor(String firebaseCode) => switch (firebaseCode) {
      'wrong-password' ||
      'user-not-found' ||
      'invalid-credential' ||
      'INVALID_LOGIN_CREDENTIALS' =>
        AppErrorCode.authInvalidCredentials,
      'email-already-in-use' => AppErrorCode.authEmailInUse,
      'weak-password' => AppErrorCode.authWeakPassword,
      'invalid-email' => AppErrorCode.authInvalidEmail,
      'network-request-failed' => AppErrorCode.networkUnreachable,
      _ => null,
    };
