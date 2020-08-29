import 'dart:async';
import 'package:AppTaxisAuto/src/models/Cliente.dart';
import 'package:AppTaxisAuto/src/models/Rating.dart';
import 'package:flutter/cupertino.dart';
import '../models/SolicitudTaxi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Oferta.dart';

class SolicitudTaxiService {

  final CollectionReference _collectionSolicitud =
      Firestore.instance.collection('col_solicitud_taxi');
  final CollectionReference _collectionCliente =
      Firestore.instance.collection('col_cliente');
  final CollectionReference _collectionRating =
      Firestore.instance.collection('col_rating');

  // Create the controller that will broadcast the posts
  final StreamController<List<SolicitudTaxi>> _solicitudController =
      StreamController<List<SolicitudTaxi>>.broadcast();

  Stream getSolicitudesList() {
      _collectionSolicitud
      .snapshots().listen((result) {
        if(result.documents.isNotEmpty){
          var solicitudes = result.documents
              .map((snapshot) => SolicitudTaxi.fromJson(snapshot.data, snapshot.documentID))
              .toList();

          _solicitudController.add(solicitudes);
        }
      });
      return _solicitudController.stream;
  } 

  Future getClienteByID(String id) async {
    try {
      var result = await _collectionCliente.document(id).get();
      //print(result.data);
      Cliente cliente = Cliente.fromJson(result.data);
      return cliente;
    } catch (e) {
      return e.toString();
    }
  }

  Future getRatingCliente(String id) async {
    try {
      var result = await _collectionRating
      .where('idCliente', isEqualTo: id)
      .getDocuments();
      
      var data;

      result.documents.forEach((doc) {
        //print(doc.data);
        data = doc.data;
      });

      Rating rating = Rating.fromJson(data);
      return rating;
    } catch (e) {
      return e.toString();
    }
  }

  Future addOferta({
    @required String documentID,
    @required Oferta oferta 
  }) async {
    try {
      await _collectionSolicitud
      .document(documentID)
      .updateData({'ofertas' : oferta.toMap()});

      return true;
    } catch (e) {
      return e.toString();
    }
  }

}
