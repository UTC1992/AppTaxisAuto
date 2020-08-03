import 'package:flutter/material.dart';
import 'ViajesScreen.dart';

class CiudadScreen extends StatefulWidget {

  _CiudadState createState() => _CiudadState();

}

class _CiudadState extends State<CiudadScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children : <Widget>[
          new Container(
            margin: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('Ir a pantalla 2'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViajesScreen(),
                  )
                );
              },
            ),
          )
        ], 
      ),
    );
  }
}