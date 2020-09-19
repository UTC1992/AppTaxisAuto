import 'package:AppTaxisAuto/src/models/Cliente.dart';
import 'package:AppTaxisAuto/src/models/Rating.dart';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/viewmodel/SolicitudTaxiViewModel.dart';
import 'package:flutter/material.dart';

const keyApiGoogle = 'AIzaSyC_CYna_nySeFMtjj--GIJIB6CvHRm0pE4';

class ItemSolicitudProceso extends StatefulWidget {
  
  ItemSolicitudProceso({
    @required this.elemento, 
    @required this.onPress,
  });

  final SolicitudTaxi elemento;
  final Function onPress;

  @override
  _ItemState createState() => new _ItemState();
}

class _ItemState extends State<ItemSolicitudProceso> {

  SolicitudTaxiViewModel _solicitudTaxiViewModel = SolicitudTaxiViewModel();
  Cliente _cliente;
  Rating _rating;
  String _nombreCliente;
  int _pedidos = 0;
  int _estrellas = 0;
  String _urlImagenCliente;
  String telefono;

  _obtenerCliente() async {
    _cliente = await _solicitudTaxiViewModel.getClienteByID(widget.elemento.clienteID);
    var nombre = _cliente.nombre.split(' ');
    setState(() {
      _nombreCliente = nombre[0];
      _urlImagenCliente = _cliente.urlImagen;
    });
  }

  _obtenerRatingCliente() async {
    _rating = await _solicitudTaxiViewModel.getRatingCliente(widget.elemento.clienteID);
    setState(() {
      _pedidos = _rating.pedidos;
      _estrellas = _calcularRating();
    });

  }

  int _calcularRating() {
    if (_rating.pedidos > 0) {
      var total = _rating.like + _rating.dislike;
      var rating = (_rating.like * 5) / total;
      return rating.toInt();
    } else {
      return 0;
    }
    
  }
  
  @override
  void initState() {
    super.initState();
    _obtenerCliente();
    _obtenerRatingCliente();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    child: _urlImagenCliente != null ?
                    Image.network(_urlImagenCliente)
                    : Image.asset('assets/img/user1.png'),
                  )
                ),
                Container(
                  width: 55,
                  child: Text(
                    _nombreCliente != null ? 
                    _nombreCliente : 'Usuario', 
                    textAlign: TextAlign.center,
                    ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow[600], size: 20,),
                    Text(_estrellas.toString(), style: TextStyle(fontSize: 12),),
                    Text(' ($_pedidos)', style: TextStyle(fontSize: 12),)
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
                      widget.elemento.origenDireccion.split(',')[0], 
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    SizedBox(height: 5.0,),
                    Text(
                      widget.elemento.destinoDireccion.split(',')[0],
                      style: TextStyle(
                        fontSize: 14,
                        ),
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on, size: 20, color: Colors.green[500],),
                        Text(widget.elemento.tarifa.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green[500]
                          ),
                        ),
                        
                      ],
                    )
                  ],
                  
                ),
              ),
            ),
            GestureDetector(
              onTap: () => widget.onPress(_cliente.telefono),
              child: Container(
                width: 45,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 3.0, color: Colors.green[500]),
                  borderRadius: BorderRadius.circular(360.0),
                  
                ),
                child: Icon(Icons.phone, color: Colors.green[500]),
              ),
            )
            
          ],
        ),
      ),
    );
  }

}
