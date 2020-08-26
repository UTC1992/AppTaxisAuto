import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:flutter/material.dart';

class ItemSolicitud extends StatefulWidget {
  
  ItemSolicitud({
    @required this.elemento, 
    @required this.onPress
  });

  final SolicitudTaxi elemento;
  final Function onPress;

  @override
  _ItemState createState() => new _ItemState();
}

class _ItemState extends State<ItemSolicitud> {

  
  
  @override
  void initState() {
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360.0),
                    color: Colors.blue[400]
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/img/user1.png'),
                  )
                ),
                Container(
                  width: 55,
                  child: Text('Omar', textAlign: TextAlign.center,),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow[600],),
                    Text('4'),
                    Text(' ( 50 )')
                  ],
                ),
              ],
              
            ),
            SizedBox(width: 5,),
            Expanded(
              
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.elemento.origenDireccion, 
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    SizedBox(height: 5.0,),
                    Text(
                      widget.elemento.destinoDireccion,
                      style: TextStyle(
                        fontSize: 14,
                        ),
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on, size: 20, color: Colors.red[900],),
                        Text(widget.elemento.tarifa.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red[900]
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.location_on, size: 20, color: Colors.grey,),
                        Text('2.5 km',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    )
                  ],
                  
                ),
              ),
            ),
            Icon(Icons.more_vert, color: Colors.grey[500])
          ],
        ),
      ),
    );
  }
}
