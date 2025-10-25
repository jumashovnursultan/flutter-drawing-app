import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final iosImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    final granted = await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 Notification permissions: $granted');
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    print('🔔 Showing notification: $title - $body');

    const notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
      ),
    );

    try {
      final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _notifications.show(id, title, body, notificationDetails);

      print('✅ Notification shown with ID: $id');
    } catch (e) {
      print('❌ Notification error: $e');
    }
  }
}
