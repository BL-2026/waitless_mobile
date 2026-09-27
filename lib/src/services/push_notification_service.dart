import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/data/sources/network/device/device_token_remote_data_source.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/presentation/cubits/language/language_cubit.dart';
import 'package:waitless_mobile/src/services/staff_session.dart';

const String floorCallsChannelId = 'floor_calls';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Title/body are already localized by the backend using the locale
  // registered with this device token; the OS displays that payload.
}

/// Registers this phone for floor-call pushes after a waitress unlocks, and
/// shows a system banner when a request arrives while the app is in front.
class PushNotificationService {
  PushNotificationService(
    this._messaging,
    this._local,
    this._tokens,
    this._session,
    this._language,
  );

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;
  final DeviceTokenRemoteDataSource _tokens;
  final StaffSession _session;
  final LanguageCubit _language;

  String? _registeredStoreId;

  AppLocalizations get _l10n => AppLocalizations(_language.state);

  Future<void> start() async {
    await _ensurePermissions();
    await _ensureAndroidChannel();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    _messaging.onTokenRefresh.listen((token) {
      final storeId = _registeredStoreId ?? _session.storeId;
      if (storeId != null) {
        _tokens.register(storeId, token, _language.state.code).ignore();
      }
    });
    _language.stream.listen((_) {
      _ensureAndroidChannel().ignore();
      if (_registeredStoreId != null) {
        registerForCurrentStore().ignore();
      }
    });
  }

  Future<void> registerForCurrentStore() async {
    final storeId = _session.storeId;
    if (storeId == null) return;

    if (Platform.isIOS && !await _waitForApnsToken()) return;

    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;

    await _tokens.register(storeId, token, _language.state.code);
    _registeredStoreId = storeId;
  }

  Future<void> unregister() async {
    final storeId = _registeredStoreId ?? _session.storeId;
    if (storeId == null) {
      _registeredStoreId = null;
      return;
    }

    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await _tokens.unregister(storeId, token);
      }
    } on Failure {
      // Signing out / ending a shift must still proceed if this call fails.
    } finally {
      _registeredStoreId = null;
    }
  }

  Future<void> _ensurePermissions() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    if (Platform.isAndroid) {
      await Permission.notification.request();
    }
  }

  Future<void> _ensureAndroidChannel() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    final l10n = _l10n;
    final channel = AndroidNotificationChannel(
      floorCallsChannelId,
      l10n.activeRequests,
      description: l10n.floorCallsChannelDescription,
      importance: Importance.high,
      playSound: true,
    );
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final l10n = _l10n;
    final title = message.notification?.title ?? l10n.notificationBrand;
    final body = message.notification?.body ?? _bodyFromData(message.data, l10n);
    if (body.isEmpty) return;

    await _local.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          floorCallsChannelId,
          l10n.activeRequests,
          channelDescription: l10n.floorCallsChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
        ),
      ),
    );
  }

  Future<bool> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 15; attempt++) {
      if (await _messaging.getAPNSToken() != null) return true;
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
    return false;
  }

  String _bodyFromData(Map<String, dynamic> data, AppLocalizations l10n) {
    final table = int.tryParse(data['tableNumber']?.toString() ?? '');
    if (table == null) return '';
    final type = data['type']?.toString();
    if (type == 'REQUEST_BILL') {
      final method = data['paymentMethod']?.toString();
      if (method != null && method.isNotEmpty) {
        return l10n.tableWantsBillWithMethod(
          table,
          l10n.paymentMethodName(method),
        );
      }
      return l10n.tableWantsBill(table);
    }
    return l10n.tableCalling(table);
  }
}
