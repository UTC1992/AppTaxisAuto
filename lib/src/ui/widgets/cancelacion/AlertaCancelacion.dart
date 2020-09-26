import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/ui/widgets/botones/BtnAceptar.dart';
import 'package:flutter/material.dart';

class AlertaCancelacion extends StatefulWidget {
  final String titulo;
  final Function accionBoton;
  final SolicitudTaxi elemento;

  AlertaCancelacion(
      {Key key,
      @required this.titulo,
      @required this.accionBoton,
      @required this.elemento})
      : super(key: key);

  StateCalificar createState() => StateCalificar();
}

class StateCalificar extends State<AlertaCancelacion> {
  

  @override
  void initState() {
    
    super.initState();
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
                height: (screenSize.height / 2),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 100,  
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Comentario',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              width: screenSize.width * 0.7,
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3.0,
                                  color: Colors.black
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                widget.elemento.motivoCancelar['cliente'],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BtnAceptar(
                      activo: true,
                      onPress: () {
                        saltarCalificacion();
                      },
                      titulo: 'Entendido',
                      alto: 50,
                      ancho: 200,
                    ),
                  ],
                )),
          ),
        ),
      ],
    ));
  }
}
