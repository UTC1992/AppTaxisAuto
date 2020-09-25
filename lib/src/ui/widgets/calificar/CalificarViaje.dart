import 'package:AppTaxisAuto/src/models/Cliente.dart';
import 'package:AppTaxisAuto/src/models/Rating.dart';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/models/Taxista.dart';
import 'package:AppTaxisAuto/src/services/SolicitudTaxiService.dart';
import 'package:AppTaxisAuto/src/viewmodel/SolicitudTaxiViewModel.dart';
import 'package:flutter/material.dart';

class CalificarViaje extends StatefulWidget {
  final String titulo;
  final Function accionBoton;
  final SolicitudTaxi elemento;

  CalificarViaje(
      {Key key,
      @required this.titulo,
      @required this.accionBoton,
      @required this.elemento})
      : super(key: key);

  StateCalificar createState() => StateCalificar();
}

class StateCalificar extends State<CalificarViaje> {
  SolicitudTaxiService _solicitudTaxiService = SolicitudTaxiService();
  SolicitudTaxiViewModel _solicitudTaxiViewModel = SolicitudTaxiViewModel();
  Cliente cliente;
  bool like = true;
  bool dislike = true;
   //rating
  Rating _ratingCliente;
  String comentarioViaje;

  @override
  void initState() {
    
    obtenerCliente();
    _obtenerRatingTaxistaCliente();
    
    super.initState();
  }

  obtenerCliente() {
    _solicitudTaxiService
        .getClienteByID(widget.elemento.clienteID)
        .then((result) {
      if (result is Cliente && result != null) {
        setState(() {
          cliente = result;
        });
      }
    });
  }

  _obtenerRatingTaxistaCliente() async {
    Rating rating2 =
        await _solicitudTaxiViewModel.getRatingCliente(widget.elemento.clienteID);
    
    setState(() {
      _ratingCliente = rating2;
    });
  }

  

  void addLikeCliente() async {

    int likeTotal = _ratingCliente.like + 1;
    int pedidosTotalClientes = _ratingCliente.pedidos + 1;
    await _solicitudTaxiViewModel
    .updateRatingLikeCliente(
      documentID: _ratingCliente.documentoID, 
      like: likeTotal,
      pedidos: pedidosTotalClientes
    );
    
    widget.accionBoton();
    
  }

  void addDisLikeCliente() async {

    int dislikeTotal = _ratingCliente.dislike + 1;
    int pedidosTotalClientes = _ratingCliente.pedidos + 1;
    await _solicitudTaxiViewModel
    .updateRatingDisLikeCliente(
      documentID: _ratingCliente.documentoID, 
      dislike: dislikeTotal,
      pedidos: pedidosTotalClientes
    );
    
    widget.accionBoton();
    
  }

  void saltarCalificacion() {
    widget.accionBoton();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
                height: (screenSize.height / 2) - 20,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    Text(
                      widget.titulo,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            addDisLikeCliente();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(
                                    width: 3, 
                                    color: 
                                      dislike ?  Colors.red[700] : Colors.grey),
                              borderRadius: BorderRadius.circular(360.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.thumb_down,
                                color: 
                                  dislike ?  Colors.red[700] : Colors.grey,
                                size: 30,
                              ),
                            )),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360.0),
                                  color: Colors.blue[400]),
                              child: ClipOval(
                                child: cliente != null
                                    ? Image.network(cliente.urlImagen)
                                    : Image.asset('assets/img/user1.png'),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              cliente != null ? cliente.nombre : '',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            addLikeCliente();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3,
                                    color:
                                        like ? Colors.green[500] : Colors.grey),
                                borderRadius: BorderRadius.circular(360.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.thumb_up,
                                  color: 
                                    like ? Colors.green[500] : Colors.grey,
                                  size: 30,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        saltarCalificacion();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Saltar',
                          style: TextStyle(fontSize: 25, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    ));
  }
}
