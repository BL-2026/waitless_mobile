/// Waitless backend. Override per target:
///
///   # deployed backend — the only option that works on a physical device without
///   # both machines being on the same Wi-Fi
///   flutter run --dart-define=WAITLESS_API_BASE_URL=https://waitless-backend.onrender.com
///
///   # a local backend from a real phone, over the LAN (Mac IP + backend port)
///   flutter run --dart-define=WAITLESS_API_BASE_URL=http://192.168.1.20:8080
///
/// The default suits the iOS simulator, which shares the host's network. Use
/// http://10.0.2.2:8080 on the Android emulator, which reaches the host on that address.
///
/// On a real iPhone, plain `http://` to a LAN address is blocked by App Transport
/// Security unless you add an Info.plist exception. An `https://` deployed backend needs
/// no exception, which is the easier path.
const String waitlessApiBaseUrl = String.fromEnvironment(
  'WAITLESS_API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

/// STOMP endpoint derived from [waitlessApiBaseUrl] (`http` → `ws`, `https` → `wss`).
String get waitlessWsUrl {
  final base = waitlessApiBaseUrl.replaceAll(RegExp(r'/+$'), '');
  if (base.startsWith('https://')) {
    return 'wss://${base.substring('https://'.length)}/ws';
  }
  if (base.startsWith('http://')) {
    return 'ws://${base.substring('http://'.length)}/ws';
  }
  return '$base/ws';
}
