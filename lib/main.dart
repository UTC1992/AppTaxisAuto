import 'package:AppTaxisAuto/src/providers/push_notifications_provider.dart';
import 'package:AppTaxisAuto/src/services/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService(),),
        Provider(create: (context) => PushNotificationProvider,)
      ],
      child: NavigationApp(),
    )
    
  );
}