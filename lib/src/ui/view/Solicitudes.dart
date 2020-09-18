import 'dart:async';
import 'package:AppTaxisAuto/src/models/ArgsSolicitudOferta.dart';
import 'package:AppTaxisAuto/src/models/ArgumentosSolicitudDatos.dart';
import 'package:AppTaxisAuto/src/models/Oferta.dart';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/models/Taxista.dart';
import 'package:AppTaxisAuto/src/services/SolicitudTaxiService.dart';
import 'package:AppTaxisAuto/src/ui/widgets/botones/BtnAceptar.dart';
import 'package:AppTaxisAuto/src/ui/widgets/indicadorProgreso/IndicadorDesc.dart';
import 'package:AppTaxisAuto/src/ui/widgets/solicitudes/ItemSolicitud.dart';
import 'package:AppTaxisAuto/src/ui/widgets/solicitudes/ItemSolicitudCliente.dart';
import 'package:AppTaxisAuto/src/viewmodel/TaxistaViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Solicitudes extends StatefulWidget {
  _SolicitudState createState() => _SolicitudState();
}

class _SolicitudState extends State<Solicitudes> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final SolicitudTaxiService _solicitudTaxiService = SolicitudTaxiService();

  List<SolicitudTaxi> _solicitudes;

  ///variable para obtener ubicacion
  Location location = new Location();

  ///verificar que el servicio de GPS este activo
  ///y que se tengan los permisos para usar GPS
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  Taxista taxista;

  _getUsuarioLogeado() async {
    print('Obtener usuario.............');
    User user = await _taxistaViewModel.getTaxistaLogeado();
    if (user != null) {
      _taxistaViewModel.getTaxistaByEmail(user.email).listen((event) {
        setState(() {
          taxista = event;
        });
      });
    }
  }

  void escucharSolicitudes() {
    _solicitudTaxiService.getSolicitudesList().listen((dataList) {
      print('ESCUCHANDO SOLICITUDES');
      List<SolicitudTaxi> updateList = dataList;
      if (updateList != null && updateList.length > 0) {
        setState(() {
          _solicitudes = updateList;
        });
      }
    });
  }

  @override
  void initState() {
    setInitialLocation();
    _getUsuarioLogeado();
    escucharSolicitudes();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setInitialLocation() async {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      print("GPS desactivado");
      return;
    } else {
      print("GPS Activo");
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      } else {
        print('Permiso negado');
      }
    }

    await _getUserLocation();
  }

  ///obtener ubicacion del cliente de la app
  _getUserLocation() async {
    location.getLocation().then((response) {
      _locationData = response;

      print('latitud' + _locationData.latitude.toString());
      setState(() {
        _locationData = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: solicitudesList(),
    );
  }

  Widget solicitudesList() {
    if (_solicitudes != null && _locationData != null) {
      var screenSize = MediaQuery.of(_scaffoldKey.currentContext).size;
      return SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black54,
                  ),
              shrinkWrap: true,
              itemCount: _solicitudes.length,
              itemBuilder: (context, index) {
                return ItemSolicitud(
                  onPress: () {
                    Navigator.pushNamed(context, '/mostrarSolicitud',
                            arguments: ArgumentosSolicitudDatos(
                                solicitudTaxi: _solicitudes[index],
                                taxista: taxista))
                        .then((value) {
                      print('MOSTRAR RESULTADO AL REGRESAR');
                      print(value);
                      if (value is ArgsSolicitudOferta) {
                        _mostrarEstadoOferta(value);
                      }
                    }).catchError((onError) {
                      print(onError.toString());
                    });
                  },
                  elemento: _solicitudes[index],
                  taxiGps: {
                    'latitude': _locationData.latitude,
                    'longitude': _locationData.longitude,
                  },
                );
              }),
        ),
      );
    } else {
      return Center(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Bienvenido. \n\nNo existen solicitudes por el momento.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            )),
      );
    }
  }

  _mostrarEstadoOferta(ArgsSolicitudOferta data) {
    /*_solicitudTaxiService
        .getEstadoOferta(idOferta: data.oferta.documentoID)
        .listen((value) {
      Oferta oferta = value;
      if (oferta != null) {
        print('OFERTA ENVIADA');
        print(oferta.documentoID);
        if (oferta.aceptada) {}
        if (oferta.rechazada) {
          print('OFERTA RECHASADA');
          //Navigator.pop(context);
          Toast.show("Oferta rechazada", _scaffoldKey.currentContext,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    }).onError((handleError) {
      print(handleError.toString());
    });
    */

    ArgsSolicitudOferta solicitudOfertaAux = data;
    solicitudOfertaAux.taxista = taxista;

    showMaterialModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: _scaffoldKey.currentContext,
        builder: (builder, scrollController) {
          var screenSize = MediaQuery.of(context).size;
          return StatefulBuilder(
                  builder: (context, setState) {
                    return WillPopScope(
                        onWillPop: () {},
                        child: Container(
                            color: Colors.white,
                            width: screenSize.width,
                            height: 250,
                            child: Column(
                              children: [
                                Container(
                                  child: ItemSolicitudCliente(
                                    onPress: () {},
                                    elemento: data.solicitudTaxi,
                                    taxiGps: {
                                      'latitude': _locationData.latitude,
                                      'longitude': _locationData.longitude,
                                    },
                                  ),
                                ),
                                IndicadorDesc(),
                                SizedBox(
                                  height: 20,
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("col_oferta")
                                      .doc(data.oferta.documentoID)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    DocumentSnapshot doc = snapshot.data;
                                    if (doc != null) {
                                      if (doc.data()['rechazada']) {
                                        return Flex(
                                          direction: Axis.vertical,
                                          children: [
                                            Container(
                                              width: screenSize.width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'La oferta fue rechazada por el pasajero, puede volver a ofertar.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Cerrar',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      } else if (doc.data()['aceptada']) {
                                        
                                        return Flex(
                                          direction: Axis.vertical,
                                          children: [
                                            Container(
                                              width: screenSize.width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '¡ Éxito ! Oferta aceptada',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 40),
                                              child: BtnAceptar(
                                                activo: true,
                                                titulo: 'Empezar',
                                                onPress: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushNamed(context, '/viajeProceso',
                                                    arguments: solicitudOfertaAux);
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Flex(
                                          direction: Axis.vertical,
                                          children: [
                                            SizedBox(height: 20,),
                                            Container(
                                              width: screenSize.width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Ofreciendo su tarifa espere la respuesta del pasajero...',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    } else {
                                      return Flex(
                                        direction: Axis.vertical,
                                        children: [
                                          Container(
                                            width: screenSize.width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'La oferta fue rechazada por el pasajero, puede volver a ofertar.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 50,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Cerrar',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            )));
                  },
                );
              
        });
  }
}
