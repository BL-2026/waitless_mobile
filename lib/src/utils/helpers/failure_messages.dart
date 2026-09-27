import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/exceptions/app_error_code.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';

/// Maps [Failure] codes to user-facing copy. Lives next to presentation so data
/// layers never import strings.
extension FailureMessages on AppLocalizations {
  String messageFor(Failure failure) {
    final code = failure.resolvedCode;

    // Firebase Auth uses its own codes as statusCode when the API code is absent.
    final firebase = _firebaseMessage(failure.statusCode);
    if (firebase != null && failure.code == null) {
      return firebase;
    }

    return switch (code) {
      AppErrorCode.networkUnreachable => networkUnreachable,
      AppErrorCode.notFound => notFoundError,
      AppErrorCode.badRequest || AppErrorCode.validationFailed => badRequestError,
      AppErrorCode.forbidden => forbiddenError,
      AppErrorCode.conflict => conflictError,
      AppErrorCode.authMissing ||
      AppErrorCode.authInvalid ||
      AppErrorCode.authSessionMissing =>
        sessionExpired,
      AppErrorCode.authUnavailable || AppErrorCode.internalError => serverError,
      AppErrorCode.authInvalidCredentials => invalidCredentials,
      AppErrorCode.authEmailInUse => emailAlreadyInUse,
      AppErrorCode.authWeakPassword => weakPassword,
      AppErrorCode.authInvalidEmail => invalidEmail,
      AppErrorCode.authGoogleFailed => googleSignInFailed,
      AppErrorCode.authResetFailed => passwordResetFailed,
      AppErrorCode.authLogoutFailed => logoutFailed,
      AppErrorCode.liveUpdatesDisconnected => liveUpdatesDisconnected,
      AppErrorCode.liveUpdatesUnauthorized => liveUpdatesUnauthorized,
      AppErrorCode.liveSyncFailed => liveSyncFailed,
      AppErrorCode.noVenueSelected => noVenueSelected,
      AppErrorCode.staffPinRequired => staffPinRequired,
      _ => unexpectedError,
    };
  }

  String? _firebaseMessage(String firebaseCode) => switch (firebaseCode) {
        'wrong-password' ||
        'user-not-found' ||
        'invalid-credential' ||
        'INVALID_LOGIN_CREDENTIALS' =>
          invalidCredentials,
        'email-already-in-use' => emailAlreadyInUse,
        'weak-password' => weakPassword,
        'invalid-email' => invalidEmail,
        'network-request-failed' => networkUnreachable,
        'too-many-requests' => tooManyAttempts,
        'user-disabled' => accountDisabled,
        _ => null,
      };
}
