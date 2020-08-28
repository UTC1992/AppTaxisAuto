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

      _addMarkersMap('Yo', _locationData.latitude, _locationData.longitude,
      Colors.blue[700], Icons.drive_eta, '', 80);
      _addMarkersMap('Cliente', widget.data.origenGPS['latitude'], 
      widget.data.origenGPS['longitude'],
      Colors.orange[500], Icons.location_on, '', 60);
      _addMarkersMap('Destino', widget.data.destinoGPS['latitude'], 
      widget.data.destinoGPS['longitude'],
      Colors.green[500], Icons.location_on, '', 60);

      print('latitud' + _locationData.latitude.toString());
      setState(() {
        mostrarMapa = true;
      });

    });
    
    //_moverCamara(_locationData.latitude, _locationData.longitude);
    
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
              height: screenSize.height/2,
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
                  ItemSolicitudCliente(
                    onPress: () {},
                    elemento: widget.data,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: BtnAceptar(
                      activo: true,
                      onPress: () {},
                      titulo: 'Aceptar por \$' + widget.data.tarifa.toString(),
                    )
                  ),
                  SizedBox(height: 10,),
                  Text('Ofrezca su precio del viaje',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10,),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BtnAceptar(
                          activo: true,
                          onPress: () {},
                          titulo: '\$ '+(widget.data.tarifa + 0.5).toString(),
                        ),
                        BtnAceptar(
                          activo: true,
                          onPress: () {},
                          titulo: '\$ '+(widget.data.tarifa + 1).toString(),
                        ),
                        BtnAceptar(
                          activo: true,
                          onPress: () {},
                          titulo: '\$ '+(widget.data.tarifa + 1.5).toString(),
                        ),
                      ],
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      width: screenSize.width/2,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Omitir', style: TextStyle(fontSize: 18),),
                    ),
                  )
                ],
              ),
            )
          ),
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
      markerList.add(marker);
    });

    if (markers.length > 2) {
      print('CENTRAR MARCADORESSSSS');
      print(markers.values.elementAt(0).position.latitude);
      await updateCameraLocation(
          LatLng(markers.values.elementAt(0).position.latitude,
              markers.values.elementAt(0).position.longitude),
          LatLng(markers.values.elementAt(2).position.latitude,
              markers.values.elementAt(2).position.longitude));
      
      
    }
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
  ) async {
    print('COORDENADAS ======================');
    print(source);
    GoogleMapController mapController = await _controllerComplete.future;

    LatLngBounds bounds = getBounds(markerList);
  
    /*if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }
*/
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

  Future<BitmapDescriptor> crearIconoMarcador(
    String contenido,
    Color clusterColor,
    Color textColor,
    int width,
  ) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = width / 2;
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );
    textPainter.text = TextSpan(
      text: contenido,
      style: TextStyle(
        fontSize: radius,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );
    final image = await pictureRecorder.endRecording().toImage(
          radius.toInt() * 2,
          radius.toInt() * 2,
        );
    final data = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
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
          width: 4
        );
  
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
        fontSize: double.parse(width.toString()),
        fontFamily: iconTaxi.fontFamily,
        color: color
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(
      radius - textPainter.width / 2,
      radius - textPainter.height / 2,));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(
      radius.toInt() * 2,
      radius.toInt() * 2,
    );
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    final bitmapDescriptor = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());

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

}
