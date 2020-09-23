import '../../services/AuthService.dart';
import 'package:flutter/material.dart';
import 'Viajes.dart';

class Ciudad extends StatefulWidget {
  _CiudadState createState() => _CiudadState();
}

class _CiudadState extends State<Ciudad>
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
                  builder: (context) => Viajes(),
                ));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('cerrar sesion'),
              onPressed: () {
              },
            ),
          ),
        ],
      )),
    );
  }
}
