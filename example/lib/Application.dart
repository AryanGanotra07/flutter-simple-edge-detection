import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:simple_edge_detection_example/constants/contant.dart';

class Application {
  static final Application _singleton = Application._internal();

  String deviceToken;

  factory Application() {
    return _singleton;
  }

  Future<void> initPlatform() async {
   await _initNotifications();
   await _initStorage();
  }


  Future<void> _initStorage() async {
    await storage.ready;
  }

  AndroidInitializationSettings settings = AndroidInitializationSettings("@mipmap/ic_launcher");

  final LocalStorage storage = new LocalStorage(Constants.LOCAL_STORAGE_KEY);


  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  void showNotification(RemoteMessage message) {

    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: android?.smallIcon,
              // other properties...
            ),
          ));
    }
  }






  Future<void> _initNotifications() async {
    await Firebase.initializeApp();
    await _createChannel();
    deviceToken = await FirebaseMessaging.instance.getToken();
    print("Device token is.. " + deviceToken);
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> _createChannel() async {


    await flutterLocalNotificationsPlugin.initialize(InitializationSettings(android: settings));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }


  void sendNotification(RemoteMessage message) {

  }

  Application._internal();
}
