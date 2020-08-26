import 'dart:async';

import '../models/SolicitudTaxi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitudTaxiService {

  final CollectionReference _collectionReference =
      Firestore.instance.collection('col_solicitud_taxi');
  // Create the controller that will broadcast the posts
  final StreamController<List<SolicitudTaxi>> _solicitudController =
      StreamController<List<SolicitudTaxi>>.broadcast();

  Stream getSolicitudesList() {
  
      _collectionReference
      .snapshots().listen((result) {
        if(result.documents.isNotEmpty){
          var solicitudes = result.documents
              .map((snapshot) => SolicitudTaxi.fromJson(snapshot.data))
              .toList();

          _solicitudController.add(solicitudes);
        }
      });
      return _solicitudController.stream;
  } 

}
