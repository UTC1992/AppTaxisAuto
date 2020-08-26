import '../models/SolicitudTaxi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitudTaxiService {
  final CollectionReference _collectionReference =
      Firestore.instance.collection('col_solicitud_taxi');

  Future addSolicitudTaxi(SolicitudTaxi solicitud) async {
    try {
      await _collectionReference.add(solicitud.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future getSolicitudesList(String ciudad) async {
    try {
      await _collectionReference
      .where('ciudad', isEqualTo: ciudad)
      .snapshots().listen((event) {

      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

}
