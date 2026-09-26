/// Stable codes from the backend `ApiError.code`, plus client-side codes for network
/// and Firebase. Presentation maps these to [AppLocalizations] — never show [Failure.message].
abstract final class AppErrorCode {
  static const networkUnreachable = 'NETWORK_UNREACHABLE';
  static const notFound = 'NOT_FOUND';
  static const badRequest = 'BAD_REQUEST';
  static const validationFailed = 'VALIDATION_FAILED';
  static const forbidden = 'FORBIDDEN';
  static const conflict = 'CONFLICT';
  static const authMissing = 'AUTH_MISSING';
  static const authInvalid = 'AUTH_INVALID';
  static const authUnavailable = 'AUTH_UNAVAILABLE';
  static const internalError = 'INTERNAL_ERROR';
  static const authSessionMissing = 'AUTH_SESSION_MISSING';
  static const authInvalidCredentials = 'AUTH_INVALID_CREDENTIALS';
  static const authEmailInUse = 'AUTH_EMAIL_IN_USE';
  static const authWeakPassword = 'AUTH_WEAK_PASSWORD';
  static const authInvalidEmail = 'AUTH_INVALID_EMAIL';
  static const authGoogleFailed = 'AUTH_GOOGLE_FAILED';
  static const authResetFailed = 'AUTH_RESET_FAILED';
  static const authLogoutFailed = 'AUTH_LOGOUT_FAILED';
  static const liveUpdatesDisconnected = 'LIVE_UPDATES_DISCONNECTED';
  static const liveUpdatesUnauthorized = 'LIVE_UPDATES_UNAUTHORIZED';
  static const liveSyncFailed = 'LIVE_SYNC_FAILED';
  static const noVenueSelected = 'NO_VENUE_SELECTED';
  static const staffPinRequired = 'STAFF_PIN_REQUIRED';
  static const unknown = 'UNKNOWN_ERROR';
}
