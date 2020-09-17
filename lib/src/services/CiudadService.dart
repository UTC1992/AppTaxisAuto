import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/Ciudad.dart';

class CiudadService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('col_ciudad');

  Future getCiudadAll() async {
    try {
      var ciudadList = await _collectionReference.get();
      if(ciudadList.docs.isNotEmpty) {
        return  ciudadList.docs
                .map((snapshot) => Ciudad.fromJson({
                  'id': snapshot.id,
                  'nombre' : snapshot.data()['nombre']}))
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