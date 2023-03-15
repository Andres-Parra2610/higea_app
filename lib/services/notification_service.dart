
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async{
    
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('flutter_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );

    tz.initializeTimeZones();

    await notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification() async{

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'cita_medica', 
        'recordatorio_cita',
        importance: Importance.high,
        priority: Priority.high
      );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );
    
    

    await notificationsPlugin.zonedSchedule(
      1, 
      'Recordatorio de cita médica', 
      'Recuerda que el día de mañana tienes una cita médica,  no la olvides!',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


}