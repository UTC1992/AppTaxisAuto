import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/solicitudes/ItemSolicitudCliente.dart';
import '../../widgets/botones/BtnAceptar.dart';
import '../../widgets/botones/BtnUbicacionCentrar.dart';
import '../../widgets/botones/BtnBack.dart';
import '../../../viewmodel/SolicitudTaxiViewModel.dart';
import '../../../models/Oferta.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';

class SolicitudDatos extends StatefulWidget {
  final SolicitudTaxi data;

  SolicitudDatos({
    Key key,
    @required this.data,
  }) : super(key: key);

  _SolicitudState createState() => _SolicitudState();
}

class _SolicitudState extends State<SolicitudDatos> {
  //solicitud view model
  SolicitudTaxiViewModel _solicitudTaxiViewModel = new SolicitudTaxiViewModel();
  Oferta _oferta = new Oferta();

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
  bool liteModeMap = false;

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  List<Marker> markerList = new List();

  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  // imagen de markers
  BitmapDescriptor pinLocationIcon;

  //crear otro objeto solicitud
  Map _taxiGPS;

  void setInitialLocation() async {
    
    var isGpsEnabled = await Geolocator().isLocationServiceEnabled();
    if(!isGpsEnabled) {
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
    }
    
    await _getUserLocation();
  }

  ///obtener ubicacion del cliente de la app
  _getUserLocation() async {
    location.getLocation().then((response) {
      _locationData = response;

      _addMarkersMap('Yo', _locationData.latitude, _locationData.longitude,
          Colors.blue[700], Icons.drive_eta, '', 80);
      _addMarkersMap(
          'Cliente',
          widget.data.origenGPS['latitude'],
          widget.data.origenGPS['longitude'],
          Colors.orange[500],
          Icons.location_on,
          '',
          60);
      _addMarkersMap(
          'Destino',
          widget.data.destinoGPS['latitude'],
          widget.data.destinoGPS['longitude'],
          Colors.green[500],
          Icons.location_on,
          '',
          60);

      print('latitud' + _locationData.latitude.toString());
      setState(() {
        mostrarMapa = true;
        _taxiGPS = {
          'latitude' : _locationData.latitude,
          'longitude' : _locationData.longitude
        };
      });
    });
  }

  ///asignar mapa aun controlador
  void _onMapCreated(GoogleMapController controller) {
    _controllerComplete.complete(controller);
    setPolylines();
    print('CREARRR MAPA');
    setState(() {
      liteModeMap = true;
    });
  }

  @override
  void initState() {
    setInitialLocation();
    super.initState();
    /*BitmapDescriptor.fromAssetImage(
         ImageConfiguration(devicePixelRatio: 2.5),
         'assets/img/destination_map_marker.png').then((onValue) {
            pinLocationIcon = onValue;
         });
    */
  }
  

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Can't get gurrent location"),
              content:
                  const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
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
              //margin: EdgeInsets.only(top: 20),
              width: screenSize.width,
              height: screenSize.height / 2,
              child: !mostrarMapa
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GoogleMap(
                      //myLocationEnabled: true,
                      //padding: EdgeInsets.symmetric(vertical: 50),
                      compassEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      //liteModeEnabled: liteModeMap,
                      indoorViewEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            _locationData.latitude, _locationData.longitude),
                        zoom: _zoom,
                      ),
                      onMapCreated: _onMapCreated,
                      markers: Set<Marker>.of(markers.values),
                      polylines: _polylines,
                    ),
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _taxiGPS != null ?
                  ItemSolicitudCliente(
                    onPress: () {},
                    elemento: widget.data,
                    taxiGps: _taxiGPS,
                  )
                  : Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: BtnAceptar(
                        activo: true,
                        onPress: () {
                          _mostrarConfirmacionOferta(widget.data.tarifa);
                        },
                        titulo:
                            'Aceptar por \$' + widget.data.tarifa.toString(),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Ofrezca su precio del viaje',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BtnAceptar(
                        activo: true,
                        onPress: () {
                          _mostrarConfirmacionOferta(widget.data.tarifa + 0.5);
                        },
                        titulo: '\$ ' + (widget.data.tarifa + 0.5).toString(),
                      ),
                      BtnAceptar(
                        activo: true,
                        onPress: () {
                          _mostrarConfirmacionOferta(widget.data.tarifa + 1);
                        },
                        titulo: '\$ ' + (widget.data.tarifa + 1).toString(),
                      ),
                      BtnAceptar(
                        activo: true,
                        onPress: () {
                          _mostrarConfirmacionOferta(widget.data.tarifa + 1.5);
                        },
                        titulo: '\$ ' + (widget.data.tarifa + 1.5).toString(),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: screenSize.width / 2,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Omitir',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            )),
        BtnUbicacionCentrar(
          bottom: (screenSize.height / 2) + 10,
          right: 10,
          onPress: () async {
            if (markers.length > 2) {
              print('CENTRAR MARCADORESSSSS');
              await updateCameraLocation();
            }
          },
        ),
        BtnBack(
            top: 30,
            left: 10,
            onPress: () {
              Navigator.pop(context);
            }),
      ],
    ));
  }

  void _addMarkersMap(String idMarker, double lat, double long, Color color,
      icono, String direccion, int width) async {
    final MarkerId markerId = MarkerId(idMarker);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      infoWindow: InfoWindow(title: idMarker, snippet: direccion),
      icon: await crearIconoMarker(icono, color, width),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
      markerList.add(marker); // lista de marcadores para luego centrar en mapa
    });

    if (markers.length > 2) {
      print('CENTRAR MARCADORESSSSS');
      await updateCameraLocation();
    }
  }

  Future<void> updateCameraLocation() async {
    print('CENRANDO MARKERS');
    GoogleMapController mapController = await _controllerComplete.future;

    LatLngBounds bounds = getBounds(markerList);
    //mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      keyApiGoogle,
      PointLatLng(widget.data.origenGPS['latitude'],
          widget.data.origenGPS['longitude']),
      PointLatLng(widget.data.destinoGPS['latitude'],
          widget.data.destinoGPS['longitude']),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Colors.blue[600],
          points: polylineCoordinates,
          width: 4);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  crearIconoMarker(icons, Color color, int width) async {
    final iconTaxi = icons;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;

    final double radius = width / 2;
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final icosStr = String.fromCharCode(iconTaxi.codePoint);
    textPainter.text = TextSpan(
      text: icosStr,
      style: TextStyle(
          letterSpacing: 0.0,
          fontSize: double.parse(width.toString()) * 0.8,
          fontFamily: iconTaxi.fontFamily,
          color: color),
    );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
          radius - textPainter.width / 2,
          radius - textPainter.height / 2,
        ));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(
      radius.toInt() * 2,
      radius.toInt() * 2,
    );
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    final bitmapDescriptor =
        BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());

    return bitmapDescriptor;
  }

  LatLngBounds getBounds(List<Marker> markersAux) {
    var lngs = markersAux.map<double>((m) => m.position.longitude).toList();
    var lats = markersAux.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    print('MARKER TOP ' + topMost.toString());

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  _mostrarConfirmacionOferta(double tarifa) {

    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(
          title: Text(
            '¿Cuánto tiempo le tomará llegar al pasajero?'
          ),

          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        BtnAceptar(
                          activo: true,
                          titulo: '3 min.',
                          onPress: () {
                            _enviarPropuestaTarifa(tarifa, context);
                            //Navigator.pushReplacementNamed(context, '/pedidos');
                          },
                        ),
                        SizedBox(height: 10,),
                        BtnAceptar(
                          activo: true,
                          titulo: '5 min.',
                          onPress: () {
                            _enviarPropuestaTarifa(tarifa, context);
                          },
                        ),
                        SizedBox(height: 10,),
                        BtnAceptar(
                          activo: true,
                          titulo: '10 min.',
                          onPress: () {
                            _enviarPropuestaTarifa(tarifa, context);
                          },
                        ),
                        SizedBox(height: 10,),
                        BtnAceptar(
                          activo: true,
                          titulo: '15 min.',
                          onPress: () {
                            _enviarPropuestaTarifa(tarifa, context);
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
        );
      },
    );
  }

  _enviarPropuestaTarifa(double tarifa, BuildContext context) async {
    print('Enviando propuesta con tarifa => ' + tarifa.toString());

    await _solicitudTaxiViewModel.addOferta(
      documentID: widget.data.documentID, 
      oferta: _oferta);
    
    //Navigator.pop(context);
    Navigator.popUntil(context, (route) => route.isFirst);

  }

}
