import 'package:flutter/material.dart';

class BtnUbicacionCentrar extends StatefulWidget {
  final Function onPress;
  final double bottom;
  final double right;
  final double top;
  final double left;

  BtnUbicacionCentrar({
    @required this.onPress,
    this.bottom,
    this.right,
    this.top,
    this.left,
  });

  @override
  _StateBtnUbicacionCentrar createState() => new _StateBtnUbicacionCentrar();
}

class _StateBtnUbicacionCentrar extends State<BtnUbicacionCentrar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: widget.bottom,
        right: widget.right,
        left: widget.left,
        top: widget.top,
        child: FloatingActionButton(
          onPressed: widget.onPress,
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(Icons.my_location),
        ));
  }
}
