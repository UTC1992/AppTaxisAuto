import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {

  @override
  StateLanding createState() => StateLanding();

}

class StateLanding extends State<Landing> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  revisarInicioSesion() {
    _auth.authStateChanges().listen((result) {
      print('REVISANDO LOGIN DEL USUARIOOO');
      print(result);

      if (result != null) {
        Navigator.pushNamed(context, '/dashboard');
      } else {
        Navigator.pushNamed(context, '/bienvenida');
      }

    });
  }

  @override
  void initState() {
    revisarInicioSesion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
