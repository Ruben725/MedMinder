import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class notificationRem{

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(NotificationResponse) async {}

  static Future<void> init() async{

    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  }

  //Instant
  static Future<void> showInstantNotification(String title, String body) async{
    const NotificationDetails platformChannelSpecifies = NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId", 
        "channelName",
        importance: Importance.high,
        priority: Priority.high
        ),
    );
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifies);
  }

  //Scheduled
  static Future<void> scheduledNotification(String title, String body, DateTime scheduledTime) async{
    const NotificationDetails platformChannelSpecifies = NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId", 
        "channelName",
        importance: Importance.high,
        priority: Priority.high
        ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, 
      title, 
      body, 
      tz.TZDateTime.from(scheduledTime, tz.local), 
      platformChannelSpecifies,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

}