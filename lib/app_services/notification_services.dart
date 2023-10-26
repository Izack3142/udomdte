import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
final FlutterLocalNotificationsPlugin flNotificationsPlugin=FlutterLocalNotificationsPlugin();

Future<void> initializeNotification()async{
 const androidInitializationSettings=AndroidInitializationSettings("@mipmap/ic_launcher");
 const iosInitializationSettings=DarwinInitializationSettings();
 const initSettings=InitializationSettings(android: androidInitializationSettings,iOS: iosInitializationSettings);
    await flNotificationsPlugin.initialize(initSettings);
}

Future<void> showNotification(String title,String body)async{
  const androidNotdetails=AndroidNotificationDetails("0","reminder",
  styleInformation: BigTextStyleInformation(''),
  importance: Importance.max,priority: Priority.max
  );
  const iosNotdetails=DarwinNotificationDetails();
  const notifDetails=NotificationDetails(android: androidNotdetails,iOS: iosNotdetails);
   await flNotificationsPlugin.periodicallyShow(0, title, body,RepeatInterval.everyMinute,notifDetails);
}

}