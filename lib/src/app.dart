import 'package:AppTaxisAuto/src/providers/push_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'navigation/RouteGenerator.dart';

class NavigationApp extends StatefulWidget {
  @override
  _NavigationAppState createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> {
  @override
  void initState() {
    super.initState();

    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          //home: Landing(),
          initialRoute: '/',
          theme: ThemeData(
              primaryColor: Colors.orange[700], accentColor: Colors.orange[600]),
          onGenerateRoute: RouteGenerator.generateRoute,
        );
  }
}