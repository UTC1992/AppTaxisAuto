import 'package:flutter/material.dart';
import 'screens/ViajesScreen.dart';
import 'navigation/Drawer.dart';
import 'screens/BienvenidaScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RegistroScreen.dart';

class NavigationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bienvenida(),
      theme: ThemeData(
        primaryColor: Colors.green[700],
        accentColor: Colors.green[600]
      ),
      routes: <String, WidgetBuilder>{ 
        '/login' : (BuildContext context) => Login(),
        '/registro' : (BuildContext context) => Registro(),
        '/pedidos' : (BuildContext context) => DrawerNavigation(),
        '/viajes': (BuildContext context) => ViajesScreen(),
      },
    );
  }
}