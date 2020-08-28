import 'package:flutter/material.dart';

class BtnAceptar extends StatefulWidget {
  
  final String titulo;
  final bool activo;
  final Function onPress;

  BtnAceptar({
    @required this.titulo,
    @required this.onPress,
    @required this.activo
  });

  @override
  _StateBtnAceptar createState() => new _StateBtnAceptar();
}

class _StateBtnAceptar extends State<BtnAceptar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        decoration: BoxDecoration(
          color: widget.activo
              ? Colors.green[700]
              : Colors.grey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            widget.titulo,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )),
      ),
    );
  }
}