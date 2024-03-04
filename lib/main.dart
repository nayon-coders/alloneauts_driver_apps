import 'package:driver/notification/local_nification.dart';
import 'package:driver/view/bottom_navigation/screen/bootom_navigation.dart';
import 'package:driver/view/flash/flash.dart';
import 'package:driver/view/permission_handler/permissoin_hendler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );

  //permission
  await PermissionHandler.requestNotificationPermissions();
  await PermissionHandler.handleLocationPermission();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);



  runApp(const MyApp());
}
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'All One Autos',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: "Poppins"
      ),
      home:  FirebaseAuth.instance.currentUser != null ? AppBottomNavigation() : Flash(),
    );
  }
}
