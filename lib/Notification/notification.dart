import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationRem{

  static final FlutterLocalNotificationsPlugin localNotification = FlutterLocalNotificationsPlugin();
  static Future<void> notifReceived(nResponse) async {}

  static Future<void> init() async{

    const AndroidInitializationSettings androidInitialization = AndroidInitializationSettings("@mipmap/ic_launcher");
    const InitializationSettings initialSettings = InitializationSettings(
      android: androidInitialization,
    );

    await localNotification.initialize(
      initialSettings,
      onDidReceiveNotificationResponse: notifReceived,
      onDidReceiveBackgroundNotificationResponse: notifReceived,
    );

    await localNotification
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();


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

    await localNotification.zonedSchedule(
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

/*
  static Future<void> _showFullScreen() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = 
      AndroidNotificationDetails(
        'full_screen', 
        'Full Screen',
        channelDescription: 'full screen notification',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,);
  }
*/
}