import 'package:flutter/material.dart';

class Viajes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Ir a pantalla 1'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}