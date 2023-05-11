import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


/// @class [NotificationService]
/// @description Servicio que configura las notificaciones locales

class NotificationService {

  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async{
    
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('logo_higea');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );

    tz.initializeTimeZones();

    await notificationsPlugin.initialize(initializationSettings);
  }




  /// @method [showNotificacion]
  /// @description Método que guarda la notificación en el dispositivo y posteriormente la muestra

  static Future<void> showNotification(int idCita, DateTime date) async{


    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final minDate = tomorrow.add(const Duration(days: 1));

    if(date.isBefore(minDate)) return;


    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'cita_medica', 
        'recordatorio_cita',
        importance: Importance.high,
        priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );

    final location = tz.local;
    //tz.TZDateTime.now(location).add(const Duration(seconds: 5)),
    final tz.TZDateTime dateNotification = tz.TZDateTime.from(date.subtract(const Duration(days: 1)), location);


    await notificationsPlugin.zonedSchedule(
      idCita, 
      'Recordatorio de cita médica', 
      'Recuerda que el día de mañana tienes una cita médica,  no la olvides!',
      tz.TZDateTime.now(location).add(const Duration(seconds: 5)),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


}