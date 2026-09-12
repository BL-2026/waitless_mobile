enum RequestStatus { open, acknowledged, resolved }

extension RequestStatusX on RequestStatus {
  /// Maps the backend's `RequestStatus` enum names.
  static RequestStatus fromApi(String value) => switch (value) {
        'OPEN' => RequestStatus.open,
        'ACKNOWLEDGED' => RequestStatus.acknowledged,
        'RESOLVED' => RequestStatus.resolved,
        _ => throw ArgumentError('Unknown request status: $value'),
      };
}
