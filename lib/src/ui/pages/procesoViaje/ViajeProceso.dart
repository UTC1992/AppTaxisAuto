import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:AppTaxisAuto/src/models/ArgsSolicitudOferta.dart';
import 'package:AppTaxisAuto/src/models/Oferta.dart';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/providers/push_notifications_provider.dart';
import 'package:AppTaxisAuto/src/services/SolicitudTaxiService.dart';
import 'package:AppTaxisAuto/src/ui/widgets/solicitudes/ItemSolicitudProceso.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/botones/BtnAceptar.dart';
import '../../widgets/botones/BtnUbicacionCentrar.dart';
import '../../../viewmodel/SolicitudTaxiViewModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

const keyApiGoogle = "AIzaSyC_CYna_nySeFMtjj--GIJIB6CvHRm0pE4";

class ViajeProceso extends StatefulWidget {
  final ArgsSolicitudOferta data;

  ViajeProceso({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _StateViajeProceso createState() => _StateViajeProceso();
}

class _StateViajeProceso extends State<ViajeProceso> {
  //solicitud view model
  SolicitudTaxiService _solicitudTaxiService = SolicitudTaxiService();
  SolicitudTaxiViewModel _solicitudTaxiViewModel = SolicitudTaxiViewModel();

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
  List<LatLng> polylineCoordinatesTaxi = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  // imagen de markers
  BitmapDescriptor pinLocationIcon;

  //crear otro objeto solicitud
  Map _taxiGPS;

  SolicitudTaxi _solicitudData;
  Oferta _oferta;
  SolicitudTaxi _solicitudEscuchar;

  //contado retroceso
  Timer _timer;
  int _start;
  int minutos;
  int contador = 0;

  void setInitialLocation() async {
    var isGpsEnabled = await Geolocator().isLocationServiceEnabled();
    if (!isGpsEnabled) {
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
          _solicitudData.origenGPS['latitude'],
          _solicitudData.origenGPS['longitude'],
          Colors.orange[500],
          Icons.location_on,
          '',
          60);
      _addMarkersMap(
          'Destino',
          _solicitudData.destinoGPS['latitude'],
          _solicitudData.destinoGPS['longitude'],
          Colors.green[500],
          Icons.location_on,
          '',
          60);

      print('latitud' + _locationData.latitude.toString());
      setState(() {
        mostrarMapa = true;
        _taxiGPS = {
          'latitude': _locationData.latitude,
          'longitude': _locationData.longitude
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

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {

          if (_start < 1) {
            timer.cancel();
          } else {
            print('segundos ==> ' + _start.toString());
            if(_start == (_oferta.tiempo * 60)) {
              
              if(contador == 0 && _start > 0) {
                contador = 59;
                minutos = minutos - 1;
              }
              _start = _start - 1;
            } else {
              _start = _start - 1;
              contador--;

              if(contador == 0 && _start > 0) {
                contador = 59;
                minutos = minutos - 1;
              }
              if(_start == 0) {
                contador = 0;
                minutos = 0;
              }
              
            }
          }
        },
      ),
    );
  }

  void _escucharEstadosSolicitud() {
    _solicitudTaxiService.getSolicitudById(widget.data.solicitudTaxi.documentID)
    .listen((doc) {
      SolicitudTaxi objeto = doc;
      print('Estado solicitud => ' + objeto.estado.toString());
      if(objeto != null) {
        setState(() {
          _solicitudEscuchar = objeto;
          if(objeto.estado == 3) {
            if (markers.containsKey(MarkerId('Cliente'))) {
              _getUserLocation();
              updateCameraLocation();
            }
            _start = 0;
            markers.remove( MarkerId('Cliente'));
            _polylines.removeWhere((poli) => poli.polylineId == PolylineId("linea1"));
          }
        });
      }

     });
  } 

  void actualizarEstado(int estado) async {
    await _solicitudTaxiViewModel
    .updateEstado(estado: estado, documentID: _solicitudData.documentID);
  }

  void terminarPedido() async {
    await _solicitudTaxiViewModel
    .finalizarPedido(documentID: _solicitudData.documentID);
    Navigator.pop(context);
  }

  @override
  void initState() {
    
    _solicitudData = widget.data.solicitudTaxi;
    _oferta = widget.data.oferta;
    minutos = _oferta.tiempo; 
    _start = _oferta.tiempo * 60;

    setInitialLocation();
    startTimer();
    _escucharEstadosSolicitud();

    super.initState();
    /*BitmapDescriptor.fromAssetImage(
         ImageConfiguration(devicePixelRatio: 2.5),
         'assets/img/destination_map_marker.png').then((onValue) {
            pinLocationIcon = onValue;
         });
    */
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () async {
              await _solicitudTaxiViewModel
              .cancelarSolicitud(documentoID: _solicitudData.documentID);
              Navigator.pop(context);
            },
            child: Container(
              width: 100,
              alignment: Alignment.center,
              child: Text(
                'Cancelar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: getProcesoViaje(context),
        ),
      ), 
      
    );
  }

  Widget getProcesoViaje(context) {
    var screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              //margin: EdgeInsets.only(top: 20),
              width: screenSize.width,
              height: screenSize.height / 2.0,
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
              color: Colors.white,
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () {
                      if (_solicitudEscuchar.estado == 2) {
                        _mostrarRuta(
                          _solicitudData.origenGPS['latitude'].toString(),
                          _solicitudData.origenGPS['longitude'].toString()
                        );
                      }
                      if (_solicitudEscuchar.estado > 2) {
                        _mostrarRuta(
                          _solicitudData.destinoGPS['latitude'].toString(),
                          _solicitudData.destinoGPS['longitude'].toString()
                        );
                      }
                      
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          
                          Text('Mostrar ruta', 
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green[500]
                            ),
                          ),
                          SizedBox(width: 10,),
                          Icon(Icons.chevron_right, color: Colors.green[500],)
                      ],
                    ),
                  ),
                  ItemSolicitudProceso(
                    onPress: _llamarAlTelefonoCliente,
                    elemento: widget.data.solicitudTaxi,
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: BtnAceptar(
                      activo: _solicitudEscuchar.estado == 2,
                      onPress: () async {
                        if(_solicitudEscuchar.estado == 2) {
                          actualizarEstado(3);
                          enviarNotificacion();
                        } else {
                          terminarPedido();
                        }
                      },
                      titulo: _solicitudEscuchar.estado == 2 
                      ? 'He llegado'
                      : 'Terminar viaje',
                    )
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            )
        ),
        BtnUbicacionCentrar(
          bottom: (screenSize.height / 2.5),
          right: 10,
          onPress: () async {
            if (markers.length > 0) {
              print('CENTRAR MARCADORES');
              await updateCameraLocation();
            }
          },
        ),
        Positioned(
          top: 10,
          child: Container(
            width: screenSize.width,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _solicitudEscuchar.estado == 2
                  ? minutos.toString() +":"+ contador.toString() 
                  : _solicitudEscuchar.estado == 3
                  ? 'Se envio una notificación al pasajero.'
                  : 'Pasajero en camino',
                  style: TextStyle(
                    fontSize: _solicitudEscuchar.estado == 2 ? 40 : 20,
                    color: _solicitudEscuchar.estado == 2 
                    ? Colors.green[500]
                    : Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
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

    List<Marker> markerListAux = new List();

    if (_solicitudEscuchar.estado == 2) {
      for (var i = 0; i < (markerList.length-1); i++) {
        markerListAux.add(markerList[i]);
      }
    }

    if (_solicitudEscuchar.estado == 3) {
      for (var i = 0; i < markerList.length; i++) {
        markerListAux.add(markerList[i]);
      }
      markerListAux.removeAt(1);
      final MarkerId markerId = MarkerId('Cliente');
      setState(() {
        markers.remove(markerId);
        _polylines.removeWhere((poli) => poli.polylineId == PolylineId("linea1"));
      });
    }

    LatLngBounds bounds = getBounds(markerListAux);
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
    PolylineResult result1 = await polylinePoints.getRouteBetweenCoordinates(
      keyApiGoogle,
      PointLatLng(_solicitudData.origenGPS['latitude'],
          _solicitudData.origenGPS['longitude']),
      PointLatLng(_solicitudData.destinoGPS['latitude'],
          _solicitudData.destinoGPS['longitude']),
      travelMode: TravelMode.driving,
    );

    PolylineResult result2 = await polylinePoints.getRouteBetweenCoordinates(
      keyApiGoogle,
      PointLatLng(_taxiGPS['latitude'], _taxiGPS['longitude']),
      PointLatLng(_solicitudData.origenGPS['latitude'],
          _solicitudData.origenGPS['longitude']),
      travelMode: TravelMode.driving,
    );

    if (result1.points.isNotEmpty) {
      result1.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    if (result2.points.isNotEmpty) {
      result2.points.forEach((PointLatLng point) {
        polylineCoordinatesTaxi.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("linea2"),
          color: Colors.blue[600],
          points: polylineCoordinates,
          width: 5);

      Polyline polylineTaxi = Polyline(
          polylineId: PolylineId("linea1"),
          color: Colors.orange[500],
          points: polylineCoordinatesTaxi,
          width: 4,
          zIndex: 1);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
      _polylines.add(polylineTaxi);
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

  Future<void> _llamarAlTelefonoCliente(String _telefono) async {
    String url = 'tel://$_telefono';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _mostrarRuta(String latitude, String longitude) async {

    String url = "https://www.google.com/maps/dir/?api=1"+
                    //'&origin='+origen.latitude+','+origen.longitude+
                    '&destination='+latitude+','+longitude+
                    '&language=es&components=country:ec'+
                    '&travelmode=driving';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  void enviarNotificacion() async {
    var notificaciones = 
    Provider.of<PushNotificationProvider>(context, listen: false); 
    await notificaciones.sendAndRetrieveMessage();

  }

}
