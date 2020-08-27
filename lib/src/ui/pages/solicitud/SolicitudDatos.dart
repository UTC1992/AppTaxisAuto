import 'dart:async';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_webservice/places.dart' as Places;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudDatos extends StatefulWidget {
  final SolicitudTaxi data;

  SolicitudDatos({
    Key key,
    @required this.data,
  }) : super(key: key);

  _SolicitudState createState() => _SolicitudState();
}

class _SolicitudState extends State<SolicitudDatos> {
  ///variable para obtener ubicacion
  Location location = new Location();

  ///verificar que el servicio de GPS este activo
  ///y que se tengan los permisos para usar GPS
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  final double _zoom = 16;
  Completer<GoogleMapController> _controllerComplete = Completer();

  ///variable para mostrar el mapa cuando este listo
  bool mostrarMapa = false;

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
    _locationData = await location.getLocation();
    print('latitud' + _locationData.latitude.toString());
    setState(() {
      mostrarMapa = true;
    });
    _moverCamara(_locationData.latitude, _locationData.longitude);
  }

  ///mover la camara a las coordenadas indicadas
  Future<void> _moverCamara(lat, long) async {
    GoogleMapController controller = await _controllerComplete.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));
  }

  ///asignar mapa aun controlador
  void _onMapCreated(GoogleMapController controller) {
    _controllerComplete.complete(controller);
  }

  @override
  void initState() {
    setInitialLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: screenSize.width,
              height: screenSize.height/2,
              child: !mostrarMapa
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GoogleMap(
                      //myLocationEnabled: true,
                      padding: EdgeInsets.only(top: 150),
                      compassEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      liteModeEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            _locationData.latitude, _locationData.longitude),
                        zoom: _zoom,
                      ),
                      onMapCreated: _onMapCreated,
                    ),
            ),
          ),
        ),
      ],
    ));
  }
}
