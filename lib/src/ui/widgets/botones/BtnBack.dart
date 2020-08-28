import 'package:flutter/material.dart';

class BtnBack extends StatefulWidget {
  final Function onPress;
  final double bottom;
  final double right;
  final double top;
  final double left;

  BtnBack({
    @required this.onPress,
    this.bottom,
    this.right,
    this.top,
    this.left,
  });

  @override
  _StateBtnBack createState() => new _StateBtnBack();
}

class _StateBtnBack extends State<BtnBack> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: widget.bottom,
        right: widget.right,
        left: widget.left,
        top: widget.top,
        child: GestureDetector(
          onTap: widget.onPress,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(360.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ));
  }
}
