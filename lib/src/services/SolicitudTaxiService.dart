import 'dart:async';
import 'package:AppTaxisAuto/src/models/Cliente.dart';
import 'package:AppTaxisAuto/src/models/Rating.dart';
import 'package:flutter/cupertino.dart';
import '../models/SolicitudTaxi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Oferta.dart';

class SolicitudTaxiService {

  final CollectionReference _collectionSolicitud =
      FirebaseFirestore.instance.collection('col_solicitud_taxi');
  final CollectionReference _collectionCliente =
      FirebaseFirestore.instance.collection('col_cliente');
  final CollectionReference _collectionRating =
      FirebaseFirestore.instance.collection('col_rating');
  final CollectionReference _collectionOferta =
      FirebaseFirestore.instance.collection('col_oferta');

  // Create the controller that will broadcast the posts
  final StreamController<List<SolicitudTaxi>> _solicitudController =
      StreamController<List<SolicitudTaxi>>.broadcast();
  final StreamController<Oferta> _ofertaController =
      StreamController<Oferta>.broadcast();

  Stream getSolicitudesList() {
      _collectionSolicitud
      .snapshots().listen((result) {
        if(result.docs.isNotEmpty){
          var solicitudes = result.docs
              .map((snapshot) => SolicitudTaxi.fromJson(snapshot.data(), snapshot.id))
              .toList();

          _solicitudController.add(solicitudes);
        }
      });
      return _solicitudController.stream;
  } 

  Future getClienteByID(String id) async {
    try {
      var result = await _collectionCliente.doc(id).get();
      //print(result.data);
      Cliente cliente = Cliente.fromJson(result.data(), result.id);
      return cliente;
    } catch (e) {
      return e.toString();
    }
  }

  Future getRatingCliente(String documentoID) async {
    try {
      var result = await _collectionRating
      .where('idCliente', isEqualTo: documentoID)
      .get();
      
      var data;
      var id;

      result.docs.forEach((doc) {
        //print(doc.data);
        data = doc.data();
        id = doc.id;
      });

      Rating rating = Rating.fromJson(data, id);
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
      var result = await _collectionOferta
      .add(oferta.toMap());

      Oferta ofertaAux = Oferta();
      ofertaAux.documentoID = result.id;
      print(result.id);

      return ofertaAux;
    } catch (e) {
      return e.toString();
    }
  }

  Stream getEstadoOferta({
    @required String idOferta
    }) {
      _collectionOferta
      .doc(idOferta)
      //.where('aceptada', isEqualTo: false)
      //.where('rechazada', isEqualTo: false)
      .snapshots().listen((doc) {
        if(doc.exists){
          var oferta = Oferta.fromJson(doc.data(), doc.id);

          _ofertaController.add(oferta);
        } else {
          Oferta _oferta = new Oferta();
          _ofertaController.add(_oferta);
        }
      });
      return _ofertaController.stream;
  } 

}
