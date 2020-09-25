import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:math';
import 'package:AppTaxisAuto/src/models/ArgsSolicitudOferta.dart';
import 'package:AppTaxisAuto/src/models/ArgumentosSolicitudDatos.dart';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/models/Taxista.dart';
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
import 'package:http/http.dart' as http;

const keyApiGoogle = "AIzaSyC_CYna_nySeFMtjj--GIJIB6CvHRm0pE4";

class SolicitudDatos extends StatefulWidget {
  final ArgumentosSolicitudDatos data;

  SolicitudDatos({
    Key key,
    @required this.data,
  }) : super(key: key);

  _SolicitudState createState() => _SolicitudState();
}

class _SolicitudState extends State<SolicitudDatos> {
  //solicitud view model
  SolicitudTaxiViewModel _solicitudTaxiViewModel = new SolicitudTaxiViewModel();

  ///variable para obtener ubicacion
  Location location = new Location();

  ///verificar que el servicio de GPS este activo
  ///y que se tengan los permisos para usar GPS
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  double _zoom = 16;
  Completer<GoogleMapController> _controllerComplete = Completer();

  ///variable para mostrar el mapa cuando este listo
  bool mostrarMapa = false;
  bool liteModeMap = false;

  Map<MarkerId, Marker> markersListMap =
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
  double _distancia;
  String _unidad;

  SolicitudTaxi _solicitudData;
  Taxista _taxista;

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
          _solicitudData.origenGPS['latitude'],
          _solicitudData.origenGPS['longitude'],
          Colors.orange[500],
          Icons.location_on,
          _solicitudData.origenDireccion,
          60);
      _addMarkersMap(
          'Destino',
          _solicitudData.destinoGPS['latitude'],
          _solicitudData.destinoGPS['longitude'],
          Colors.green[500],
          Icons.location_on,
          _solicitudData.destinoDireccion,
          60);

      print('latitud' + _locationData.latitude.toString());
      setState(() {
        mostrarMapa = true;
        _taxiGPS = {
          'latitude' : _locationData.latitude,
          'longitude' : _locationData.longitude
        };
      });

      _obtenerDistanciaKM(_taxiGPS, _solicitudData.origenGPS);
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
    _solicitudData = widget.data.solicitudTaxi;
    _taxista = widget.data.taxista;
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
              //margin: EdgeInsets.only(top: 20),
              width: screenSize.width,
              height: screenSize.height - ((screenSize.height / 3) + 50),
              child: !mostrarMapa && 
                    _polylines != null && 
                    markerList != null
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
                      markers: Set<Marker>.of(markersListMap.values),
                      polylines: _polylines,
                    ),
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              width: screenSize.width,
              height: (screenSize.height / 3) + 50,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _taxiGPS != null ?
                  ItemSolicitudCliente(
                    onPress: () {},
                    elemento: _solicitudData,
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
                          _mostrarConfirmacionOferta(_solicitudData.tarifa);
                        },
                        titulo:
                            'Aceptar por \$ ' + _solicitudData.tarifa.toString(),
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
                          _mostrarConfirmacionOferta(_solicitudData.tarifa + 0.5);
                        },
                        titulo: '\$ ' + (_solicitudData.tarifa + 0.5).toString(),
                      ),
                      BtnAceptar(
                        activo: true,
                        onPress: () {
                          _mostrarConfirmacionOferta(_solicitudData.tarifa + 1);
                        },
                        titulo: '\$ ' + (_solicitudData.tarifa + 1).toString(),
                      ),
                      BtnAceptar(
                        activo: true,
                        onPress: () {
                          _mostrarConfirmacionOferta(_solicitudData.tarifa + 1.5);
                        },
                        titulo: '\$ ' + (_solicitudData.tarifa + 1.5).toString(),
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
          bottom: screenSize.height / 2.5,
          right: 10,
          onPress: () async {
            if (markersListMap.length > 2) {
              print('CENTRAR MARCADORESSSSS');
              await updateCameraLocation();
            }
          },
        ),
        BtnBack(
            top: screenSize.height / 12,
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
      markersListMap[markerId] = marker;
      markerList.add(marker); // lista de marcadores para luego centrar en mapa
    });

    if (markersListMap.length > 2) {
      print('CENTRAR MARCADORESSSSS');
      await updateCameraLocation();
    }
  }

  Future<void> updateCameraLocation() async {
    print('CENRANDO MARKERS');
    GoogleMapController mapController = await _controllerComplete.future;

    LatLngBounds bounds = getBounds(markerList);
    //mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, _zoom);

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
      PointLatLng(_taxiGPS['latitude'],
          _taxiGPS['longitude']),
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
          polylineId: PolylineId("linea1"),
          color: Colors.blue[600],
          points: polylineCoordinates,
          width: 5);
      
      Polyline polylineTaxi = Polyline(
          polylineId: PolylineId("linea2"),
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
    //final Paint paint = Paint()..color = Color.fromRGBO(100, 100, 100, 0.2);
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
                            int tiempo = 3;
                            _enviarPropuestaTarifa(context, tarifa, tiempo);
                            //Navigator.pushReplacementNamed(context, '/pedidos');
                          },
                        ),
                        SizedBox(height: 10,),
                        BtnAceptar(
                          activo: true,
                          titulo: '5 min.',
                          onPress: () {
                            int tiempo = 5;
                            _enviarPropuestaTarifa(context, tarifa, tiempo);
                          },
                        ),
                        SizedBox(height: 10,),
                        BtnAceptar(
                          activo: true,
                          titulo: '10 min.',
                          onPress: () {
                            int tiempo = 10;
                            _enviarPropuestaTarifa(context, tarifa, tiempo);
                          },
                        ),
                        SizedBox(height: 10,),
                        BtnAceptar(
                          activo: true,
                          titulo: '15 min.',
                          onPress: () {
                            int tiempo = 15;
                            _enviarPropuestaTarifa(context, tarifa, tiempo);
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

  _enviarPropuestaTarifa(BuildContext context, double tarifa, int tiempo) async {
    print('Enviando propuesta con tarifa => ' + tarifa.toString());
    
    Oferta oferta = new Oferta();
    oferta.tarifa = tarifa;
    oferta.tiempo = tiempo;
    oferta.distancia =_distancia.toString() + " " + _unidad;
    oferta.mostrar = true;
    oferta.aceptada = false;
    oferta.rechazada = false;
    oferta.idTaxi = _taxista.documentId;
    oferta.idSolicitud = _solicitudData.documentID;


    var result = await _solicitudTaxiViewModel.addOferta(
      documentID: _solicitudData.documentID, 
      oferta: oferta);

    Oferta ofertaAux = result;
    
    //añadir id a objeto oferta
    oferta.documentoID = ofertaAux.documentoID;
    
    print('ID OFERTA => ' + ofertaAux.documentoID);

    ArgsSolicitudOferta argsSolicitudOferta = ArgsSolicitudOferta();
    argsSolicitudOferta.solicitudTaxi = _solicitudData;
    argsSolicitudOferta.oferta = oferta;

    Navigator.pop(context);
    Navigator.pop(context, argsSolicitudOferta);
    
    //Navigator.popUntil(context, (route) => route.isFirst);

  }

}
