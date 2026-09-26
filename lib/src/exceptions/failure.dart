import 'package:equatable/equatable.dart';
import 'package:waitless_mobile/src/exceptions/app_error_code.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.statusCode,
    this.code,
  });

  /// Debug / log detail. Never show this string in the UI.
  final String message;

  /// HTTP status as a string, or a Firebase error code when from Auth.
  final String statusCode;

  /// Stable app / API code used for localization. Prefer this over [message].
  final String? code;

  String get resolvedCode =>
      code ?? _codeFromStatus(statusCode) ?? AppErrorCode.unknown;

  static String? _codeFromStatus(String statusCode) {
    return switch (statusCode) {
      '0' => AppErrorCode.networkUnreachable,
      '400' => AppErrorCode.badRequest,
      '401' => AppErrorCode.authInvalid,
      '403' => AppErrorCode.forbidden,
      '404' => AppErrorCode.notFound,
      '409' => AppErrorCode.conflict,
      '503' => AppErrorCode.authUnavailable,
      '500' || '502' || '504' => AppErrorCode.internalError,
      _ => null,
    };
  }

  @override
  List<Object?> get props => [message, statusCode, code];
}

class ApiFailure extends Failure {
  const ApiFailure({
    required super.message,
    required super.statusCode,
    super.code,
  });

  ApiFailure.fromException(ApiFailure exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
          code: exception.code,
        );
}
