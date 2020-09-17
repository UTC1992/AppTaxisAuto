import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/Taxista.dart';

class TaxistaService {
  final CollectionReference _collectionTaxista =
      FirebaseFirestore.instance.collection('col_taxista');
  
  // Create the controller that will broadcast the posts
  final StreamController<Taxista> _taxistaController =
      StreamController<Taxista>.broadcast();
  
  Future addTaxista(Taxista taxista) async {
    try {
      await _collectionTaxista.add(taxista.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Stream getTaxistaByEmail(String email) {
    try {
      _collectionTaxista
      .where('email', isEqualTo: email)
      .snapshots().listen((result) {
        
        //convertir a objeto taxista
        var data;
        var id;
        result.docs.forEach((res) {
          print(res.data()['nombre']);
          data = res.data();
          id = res.id;
        });
        Taxista taxista = Taxista.fromJson(data, id);
        _taxistaController.add(taxista);
       });

      return _taxistaController.stream;
    } catch (e) {
      return e;
    }
  }

  Future updateNombre({
    @required String documentID, 
    @required String nombre,
  }) async {
    try {
      await _collectionTaxista
      .doc(documentID)
      .update({'nombre':nombre});

      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateTelefono({
    @required String documentID, 
    @required String telefono,
  }) async {
    try {
      await _collectionTaxista
      .doc(documentID)
      .update({'telefono': telefono});

      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateUrlImagen({
    @required String documentID, 
    @required String urlImagen,
  }) async {
    try {
      await _collectionTaxista
      .doc(documentID)
      .update({'urlImagen': urlImagen});

      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateCorreo({
    @required String documentID, 
    @required String email,
  }) async {
    try {
      await _collectionTaxista
      .doc(documentID)
      .update({'email': email});

      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateCiudad({
    @required String documentID, 
    @required String ciudad,
  }) async {
    try {
      await _collectionTaxista
      .doc(documentID)
      .update({'ciudad': ciudad});

      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateToken({
    @required String documentID, 
    @required String token,
  }) async {
    try {
      await _collectionTaxista
      .doc(documentID)
      .update({'token':token});

      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future getIdDocument(String email) async {
    try {
      QuerySnapshot result = await _collectionTaxista
      .where('email', isEqualTo: email)
      .get();

      return result;
    } catch (e) {
      return e;
    }
  }

}
