import 'package:flutter/material.dart';
import 'ui/view/Viajes.dart';
import 'navigation/Drawer.dart';
import 'ui/view/Landing.dart';
import 'ui/view/Login.dart';
import 'ui/view/Registro.dart';
import 'services/AuthService.dart';
import 'package:provider/provider.dart';

class NavigationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthService(), 
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
              return MaterialPageRoute(builder: (context)=> Viajes());
              break;
          }
        },
      )
    );
  }
}
