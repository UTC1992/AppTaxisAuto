import 'package:flutter/material.dart';

class Bienvenida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenida'),
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
                child: Text('Iniciar sesión'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/registro');
                },
                child: Text('Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
