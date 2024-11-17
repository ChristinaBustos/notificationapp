import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Estoy capturando el mensaje: ${message.notification!.title}");
}

const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_lancher');
final DarwinInitializationSettings initializationSettingsDarwin = const DarwinInitializationSettings();
final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsDarwin
);
// adasdasds

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingHandler);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
   @override
   State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  void initState(){
    super.initState();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage){
      print("Estoy obteniendo una notidicación");
      print("${remoteMessage.data}");
      flutterLocalNotificationsPlugin.show(
        remoteMessage.hashCode,
        remoteMessage.notification?.title,
        remoteMessage.notification?.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "Id de Prueba",
             "Canal de prueba",
             channelDescription: 'Desmostartion',
             importance: Importance.max,
             priority: Priority.max )
        )
      );
      if(remoteMessage.notification!=null){
        print("object':${remoteMessage.notification}");
      }
      
    });
    FirebaseMessaging.instance.getToken().then((token){
      print("Token del dispositivo: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
   return  MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text("Notificaciones Push"),),
      body: const Center(
        child: Text("Esperando Notifiaciones"),
      ),
    ),
   );
  }
}