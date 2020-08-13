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
        //home: Landing(),
        initialRoute: '/',
        theme: ThemeData(
            primaryColor: Colors.green[700], accentColor: Colors.green[600]),
        /*routes: <String, WidgetBuilder>{
          '/': (context) => Landing(),
          '/login': (context) => Login(),
          '/registro': ( context) => Registro(),
          '/pedidos': ( context) => DrawerNavigation(),
          '/viajes': ( context) => ViajesScreen(),
        },
        */
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context)=> Landing());
              break;
            case '/login':
              return MaterialPageRoute(builder: (context)=> Login());
              break;
            case '/registro':
              return MaterialPageRoute(builder: (context)=> Registro());
              break;
            case '/pedidos':
              return MaterialPageRoute(builder: (context)=> DrawerNavigation());
              break;
            case '/viajes':
              return MaterialPageRoute(builder: (context)=> ViajesScreen());
              break;
          }
        },
      )
    );
  }
}
