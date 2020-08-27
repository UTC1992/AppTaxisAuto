import 'package:AppTaxisAuto/src/models/SolicitudTaxi.dart';
import 'package:AppTaxisAuto/src/services/SolicitudTaxiService.dart';
import 'package:AppTaxisAuto/src/ui/widgets/solicitudes/ItemSolicitud.dart';
import 'package:flutter/material.dart';

class Solicitudes extends StatefulWidget {
  _SolicitudState createState() => _SolicitudState();
}

class _SolicitudState extends State<Solicitudes> {
  final SolicitudTaxiService _solicitudTaxiService = SolicitudTaxiService();

  List<SolicitudTaxi> _solicitudes;

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
    escucharSolicitudes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: solicitudesList(),
    );
  }

  Widget solicitudesList() {
    if(_solicitudes != null) {
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
                    arguments: _solicitudes[index]);
                  },
                  elemento: _solicitudes[index],
                );
              }),
        ),
      );
    } else { 
      return Center (
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text ("Bienvenido. \n\nNo existen solicitudes por el momento.", 
          textAlign: TextAlign.center, 
          style: TextStyle (fontSize: 20.0),)),
      );
    }
  }

}
