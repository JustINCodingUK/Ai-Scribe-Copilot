class LocalNotificationManager {

  LocalNotificationManager._();

  static LocalNotificationManager? _instance;

  static LocalNotificationManager get() {
    _instance ??= LocalNotificationManager._();
    return _instance!;
  }



}