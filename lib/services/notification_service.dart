import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Institutional Notification Service for The Gandhigram Rural Institute.
/// Handles local device notifications for official circulars, exam schedules,
/// and academic alerts with proper Android 13+ POST_NOTIFICATIONS permission.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  static const String channelIdOfficial = 'gri_official_notices';
  static const String channelNameOfficial = 'Official University Circulars';
  static const String channelDescOfficial =
      'Circulars, office orders, and urgent notifications from GRI';

  static const String channelIdExams = 'gri_exam_alerts';
  static const String channelNameExams = 'Examination & Academic Alerts';
  static const String channelDescExams =
      'Hall ticket availability, exam schedules, and academic deadlines';

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked with payload: ${response.payload}');
        },
      );

      // Create Android Notification Channels for API 26+
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            channelIdOfficial,
            channelNameOfficial,
            description: channelDescOfficial,
            importance: Importance.high,
          ),
        );
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            channelIdExams,
            channelNameExams,
            description: channelDescExams,
            importance: Importance.defaultImportance,
          ),
        );
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  /// Explicitly request Android 13+ (API 33+) POST_NOTIFICATIONS permission
  Future<bool> requestPermissions() async {
    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestNotificationsPermission();
        return granted ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Notification permission request error: $e');
      return false;
    }
  }

  /// Deliver a local device notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = channelIdOfficial,
    String channelName = channelNameOfficial,
    String? channelDescription,
    Importance importance = Importance.high,
    Priority priority = Priority.high,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription ?? channelDescOfficial,
        importance: importance,
        priority: priority,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(body),
      );

      final details = NotificationDetails(android: androidDetails);
      await _notificationsPlugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  /// Sends a verified institutional test alert to confirm device notification channel is working
  Future<bool> showTestNotification() async {
    await requestPermissions();
    await showNotification(
      id: 999,
      title: '🏛️ GRI Official Notification Alert',
      body:
          'Notifications are active! You will receive verified circulars, exam alerts, and administrative updates on this device.',
      channelId: channelIdOfficial,
      channelName: channelNameOfficial,
    );
    return true;
  }
}
