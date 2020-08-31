import 'package:AppTaxisAuto/src/models/ArgumentosSolicitudDatos.dart';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/models/Taxista.dart';
import 'package:AppTaxisAuto/src/services/SolicitudTaxiService.dart';
import 'package:AppTaxisAuto/src/ui/widgets/solicitudes/ItemSolicitud.dart';
import 'package:AppTaxisAuto/src/ui/widgets/solicitudes/ItemSolicitudCliente.dart';
import 'package:AppTaxisAuto/src/viewmodel/TaxistaViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Solicitudes extends StatefulWidget {
  _SolicitudState createState() => _SolicitudState();
}

class _SolicitudState extends State<Solicitudes> {
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
    FirebaseUser user = await _taxistaViewModel.getTaxistaLogeado();
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

  void setInitialLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
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
      body: solicitudesList(),
    );
  }

  Widget solicitudesList() {
    if (_solicitudes != null && _locationData != null) {
      var screenSize = MediaQuery.of(context).size;
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
                      if (value is SolicitudTaxi) {
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

  _mostrarEstadoOferta(SolicitudTaxi solicitud) {
    bool cerrarModal = false;

    showMaterialModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (builder, scrollController) {
          var screenSize = MediaQuery.of(context).size;
          return WillPopScope(
              onWillPop: (){},
              child: Container(
                  width: screenSize.width,
                  height: 200,
                  child: Column(
                    children: [
                      Container(
                        child: ItemSolicitudCliente(
                          onPress: () {},
                          elemento: solicitud,
                          taxiGps: {
                            'latitude': _locationData.latitude,
                            'longitude': _locationData.longitude,
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Cerrar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  )));
        });
  }

  /*
  _mostrarEstadoOferta(SolicitudTaxi solicitud) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {},
          child: SimpleDialog(
            title: Text('¿Cuánto tiempo le tomará llegar al pasajero?'),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ItemSolicitudCliente(
                          onPress: () {},
                          elemento: solicitud,
                          taxiGps: {
                            'latitude': _locationData.latitude,
                            'longitude': _locationData.longitude,
                          },
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Cerrar',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  */
}
