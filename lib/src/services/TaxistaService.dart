import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/Taxista.dart';

class TaxistaService {
  final CollectionReference _collectionReference =
      Firestore.instance.collection('col_taxista');
  
  // Create the controller that will broadcast the posts
  final StreamController<Taxista> _taxistaController =
      StreamController<Taxista>.broadcast();
  
  Future addTaxista(Taxista taxista) async {
    try {
      await _collectionReference.add(taxista.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Stream getTaxistaByEmail(String email) {
    try {
      _collectionReference
      .where('email', isEqualTo: email)
      .snapshots().listen((result) {
        
        //convertir a objeto taxista
        var data;

        result.documents.forEach((res) {
          //print(res.data['nombre']);
          data = {
            'id' : res.documentID,
            'nombre' : res.data['nombre'],
            'cedula' : res.data['cedula'],
            'email' : res.data['email'],
            'telefono' : res.data['telefono'],
            'ciudad' : res.data['ciudad'],
            'urlImagen' : res.data['urlImagen'],
          };
        });
        Taxista taxista = Taxista.fromJson(data);
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
      await _collectionReference
      .document(documentID)
      .updateData({'nombre':nombre});

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
      await _collectionReference
      .document(documentID)
      .updateData({'telefono': telefono});

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
      await _collectionReference
      .document(documentID)
      .updateData({'urlImagen': urlImagen});

      return true;
    } catch (e) {
      return e.toString();
    }
  }

}
