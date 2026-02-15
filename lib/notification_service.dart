import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool shouldShowReflection = false;
    static bool shouldShowRecap = false;
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == 'reflection') {
          shouldShowReflection = true;
        } else if (details.payload == 'recap') { 
      shouldShowRecap = true;
    }
      },
    );
  }

  static Future<void> scheduleReflection() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reflection_channel',
          'Reflection Notifications',
          channelDescription: 'asks if scrolling was worth it',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      0,
      'hey jack...',
      'was the scrolling worth it? 👀',
      tz.TZDateTime.now(tz.local).add(const Duration(minutes: 10)),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'reflection',
    );
  }

  static Future<void> scheduleDailyRecap() async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 22, 0);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    final scheduledTZ = tz.TZDateTime.from(scheduledTime, tz.local);
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'recap_channel',
          'Recap Notifications',
          channelDescription: 'click for daily recap',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      1,
      'hi cutie',
      'click to see ur instagram stats for today',
      scheduledTZ,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'recap',
    );
  }
}
