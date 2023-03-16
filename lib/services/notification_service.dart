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

  static Future<void> showNotification(int idCita, DateTime date) async{

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'cita_medica', 
        'recordatorio_cita',
        importance: Importance.high,
        priority: Priority.high
      );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );

    final location = tz.local;
    final tz.TZDateTime dateNotification = tz.TZDateTime.from(date.subtract(const Duration(days: 1)), location);


    await notificationsPlugin.zonedSchedule(
      idCita, 
      'Recordatorio de cita médica', 
      'Recuerda que el día de mañana tienes una cita médica,  no la olvides!',
      dateNotification,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


}