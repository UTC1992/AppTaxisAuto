import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/Ciudad.dart';

class CiudadService {
  final CollectionReference _collectionReference =
      Firestore.instance.collection('col_ciudad');

  Future getCiudadAll() async {
    try {
      var ciudadList = await _collectionReference.getDocuments();
      if(ciudadList.documents.isNotEmpty) {
        return  ciudadList.documents
                .map((snapshot) => Ciudad.fromJson({
                  'id': snapshot.documentID,
                  'nombre' : snapshot.data['nombre']}))
                .toList();
      }
    } catch (e) {
      if (e is PlatformException) { 
        return e.message; 
      }
      return e;
    }
  }
}