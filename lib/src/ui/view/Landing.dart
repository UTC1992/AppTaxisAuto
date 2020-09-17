import 'package:AppTaxisAuto/src/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Bienvenida.dart';
import '../../navigation/DrawerNavigation.dart';

class Landing extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthService authFirebase = Provider.of<AuthService>(context);
    return StreamBuilder<User>(
          stream: authFirebase.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User user = snapshot.data;
              if(user == null) {
                return Bienvenida();
              } else {
                print(user.email);
                return DrawerNavigation();
              }

            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        );
  }
}
