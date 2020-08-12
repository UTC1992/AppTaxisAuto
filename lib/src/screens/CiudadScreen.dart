import 'package:AppTaxisAuto/src/services/AuthFirebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ViajesScreen.dart';

class CiudadScreen extends StatefulWidget {
  _CiudadState createState() => _CiudadState();
}

class _CiudadState extends State<CiudadScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('Ir a pantalla 2'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViajesScreen(),
                ));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('cerrar sesion'),
              onPressed: () {
                AuthFirebase auth = AuthFirebase();
                auth.signOut();
              },
            ),
          ),
        ],
      )),
    );
  }
}
