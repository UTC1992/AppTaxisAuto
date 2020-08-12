import 'package:AppTaxisAuto/src/services/AuthFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'BienvenidaScreen.dart';
import '../navigation/Drawer.dart';

class Landing extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    AuthFirebase authFirebase = Provider.of<AuthFirebase>(context);
    return StreamBuilder<FirebaseUser>(
          stream: authFirebase.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              FirebaseUser user = snapshot.data;
              if(user == null) {
                return Bienvenida();
              } else {
                print(user.email);
                Navigator.pop(context);
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
