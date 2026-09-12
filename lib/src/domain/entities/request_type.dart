enum RequestType { callWaiter, requestBill }

extension RequestTypeX on RequestType {
  /// Maps the backend's `RequestType` enum names.
  static RequestType fromApi(String value) => switch (value) {
        'CALL_WAITER' => RequestType.callWaiter,
        'REQUEST_BILL' => RequestType.requestBill,
        _ => throw ArgumentError('Unknown request type: $value'),
      };
}
