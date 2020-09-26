import 'package:flutter/material.dart';

class BtnAceptar extends StatefulWidget {
  
  final String titulo;
  final bool activo;
  final Function onPress;
  final double ancho;
  final double alto;

  BtnAceptar({
    @required this.titulo,
    @required this.onPress,
    @required this.activo,
    this.ancho,
    this.alto
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
        height: widget.alto,
        width: widget.ancho,
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
