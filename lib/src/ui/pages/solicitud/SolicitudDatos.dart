import 'dart:async';
import 'dart:ui';
import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_webservice/places.dart' as Places;
import 'package:flutter_google_places/flutter_google_places.dart';
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

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

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
      Colors.orange[500], 'A', '');
      _addMarkersMap('Cliente', widget.data.origenGPS['latitude'], 
      widget.data.origenGPS['longitude'],
      Colors.orange[500], 'C', '');
      _addMarkersMap('Destino', widget.data.destinoGPS['latitude'], 
      widget.data.destinoGPS['longitude'],
      Colors.orange[500], 'D', '');

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
                      padding: EdgeInsets.only(top: 120),
                      compassEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      //liteModeEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            _locationData.latitude, _locationData.longitude),
                        zoom: _zoom,
                      ),
                      onMapCreated: _onMapCreated,
                      markers: Set<Marker>.of(markers.values),
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
      String letra, String direccion) async {
    final MarkerId markerId = MarkerId(idMarker);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      icon: await crearIconoMarcador(
        letra,
        color,
        Colors.white,
        80,
      ),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(title: idMarker, snippet: direccion),
      
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
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

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
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

    //mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);

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
        fontSize: radius - 5,
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



}
