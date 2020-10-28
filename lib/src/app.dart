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
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: Colors.orange[800],
            accentColor: Colors.cyan[600],
            
            buttonColor: Colors.orange[800],

            // Define the default font family.
            fontFamily: 'Helvetica',

            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText1: TextStyle(fontSize: 16.0, ),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
            ),
          ),
          onGenerateRoute: RouteGenerator.generateRoute,
        );
  }
}