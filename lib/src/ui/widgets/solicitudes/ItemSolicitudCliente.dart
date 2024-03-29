import 'dart:convert';

import 'package:AppTaxisAuto/src/models/Cliente.dart';
import 'package:AppTaxisAuto/src/models/Rating.dart';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/viewmodel/SolicitudTaxiViewModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const keyApiGoogle = 'AIzaSyC_CYna_nySeFMtjj--GIJIB6CvHRm0pE4';

class ItemSolicitudCliente extends StatefulWidget {
  
  ItemSolicitudCliente({
    @required this.elemento, 
    @required this.onPress,
    @required this.taxiGps
  });

  final SolicitudTaxi elemento;
  final Map taxiGps;
  final Function onPress;

  @override
  _ItemState createState() => new _ItemState();
}

class _ItemState extends State<ItemSolicitudCliente> {

  SolicitudTaxiViewModel _solicitudTaxiViewModel = SolicitudTaxiViewModel();
  Cliente _cliente;
  Rating _rating;
  String _nombreCliente;
  int _pedidos = 0;
  int _estrellas = 0;
  String _urlImagenCliente;
  double _distancia = 0;
  String _unidad = 'm';

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
    _obtenerDistanciaKM(
      widget.taxiGps,
      widget.elemento.origenGPS);
  }
  
  @override
  Widget build(BuildContext context) {
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.orange[500],),
                        Text(
                          widget.elemento.origenDireccion.split(',')[0], 
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                            ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.green[500],),
                        Text(
                          widget.elemento.destinoDireccion.split(',')[0],
                          style: TextStyle(
                            fontSize: 14,
                            ),
                        ),
                      ]
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
                        Text('$_distancia $_unidad',
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
            //Icon(Icons.more_vert, color: Colors.grey[500])
          ],
        ),
      ),
    );
  }

  _obtenerDistanciaKM(Map origen, Map destino) async {

    print('ORIGEN COORDENADAS');
    print(origen['latitude'].toString());

    String url =  'https://maps.googleapis.com/maps/api/directions/json?'+
                  'origin='+origen['latitude'].toString()+','
                  +origen['longitude'].toString()+
                  '&destination='+destino['latitude'].toString()+','
                  +destino['longitude'].toString()+
                  '&language=es&components=country:ec'+
                  //'&types=(regions)'+
                  '&key='+keyApiGoogle;
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        //print(response.body);
        Map<String, dynamic> result = jsonDecode(response.body);
        //print(result['routes'][0]['legs'][0]['distance']['value']);
        
        double distancia = double.parse(
          result['routes'][0]['legs'][0]['distance']['value'].toString());
        
        String kmText = (distancia / 1000).toStringAsFixed(2);
        double km = double.parse(kmText);
        //print(km);
        
        setState(() {
          _distancia = distancia > 1000 ? 
                      km : distancia;
          _unidad = distancia > 1000 ? 
                      'km' : 'm';
        });
        
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        throw Exception('fallo la respuesta del servidor');
      }
    } catch (e) {
      print(e.toString());
    }

  }

}
