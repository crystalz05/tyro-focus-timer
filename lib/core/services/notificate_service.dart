import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_strings.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // ask at the right moment, not at startup
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showSessionCompleteNotification({
    required bool isWorkSession,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'focus_timer_channel',
      'Focus Timer',
      channelDescription: 'Notifies you when a focus session ends',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );
    const details =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      0,
      AppStrings.sessionCompleteTitle,
      isWorkSession
          ? AppStrings.workCompleteBody
          : AppStrings.breakCompleteBody,
      details,
    );
  }
}