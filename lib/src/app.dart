import 'package:flutter/material.dart';
import 'screens/ViajesScreen.dart';
import 'navigation/Drawer.dart';
import 'screens/Landing.dart';
import 'screens/LoginScreen.dart';
import 'screens/RegistroScreen.dart';
import 'services/AuthFirebase.dart';
import 'package:provider/provider.dart';

class NavigationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthFirebase(), 
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Landing(),
        theme: ThemeData(
            primaryColor: Colors.green[700], accentColor: Colors.green[600]),
        routes: <String, WidgetBuilder>{
          '/login': (context) => Login(),
          '/registro': ( context) => Registro(),
          '/pedidos': ( context) => DrawerNavigation(),
          '/viajes': ( context) => ViajesScreen(),
        },
      )
    );
  }
}
