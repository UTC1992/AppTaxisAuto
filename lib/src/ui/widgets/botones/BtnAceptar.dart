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
        width: widget.ancho,
        height: widget.alto,
        decoration: BoxDecoration(
          color: widget.activo
              ? Theme.of(context).buttonColor
              : Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
            widget.titulo,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),),
      ),
    );
  }
}
