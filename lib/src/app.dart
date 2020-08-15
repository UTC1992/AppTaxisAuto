import 'package:flutter/material.dart';
import 'services/AuthService.dart';
import 'package:provider/provider.dart';
import 'navigation/RouteGenerator.dart';

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
        onGenerateRoute: RouteGenerator.generateRoute,
      )
    );
  }
}
