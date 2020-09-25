import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../services/TaxistaService.dart';
import '../services/AuthService.dart';
import '../models/Taxista.dart';

class TaxistaViewModel {
  final TaxistaService _taxistaService = TaxistaService();
  final AuthService _authService = AuthService();
  final StreamController<Taxista> _taxistaController =
      StreamController<Taxista>.broadcast();

  Future getTaxistaLogeado() async {
    User result = await _authService.currentUser();
    if (result is String) {
      print('no se puedo obtener el usuario');
      return null;
    } else {
      print('UID user logeado => '+result.uid);
      return result;
      
    }
  }

  Stream getTaxistaByEmail(String email){
    _taxistaService.getTaxistaByEmail(email)
    .listen((result) {
      _taxistaController.add(result);
    })
    .onError((error) {
      print(error);
    });

    return _taxistaController.stream;
  }

  Future updateNombre({
      @required String nombre,
      @required String documentID,
  }) async {
    var result = await _taxistaService.
    updateNombre(documentID: documentID, nombre: nombre);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar nombre');
    }

  }

  Future updateTelefono({
      @required String telefono,
      @required String documentID,
  }) async {
    var result = await _taxistaService.
    updateTelefono(documentID: documentID, telefono: telefono);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar telefono');
    }

  }

  Future updateUrlImagen({
      @required String urlImagen,
      @required String documentID,
  }) async {
    var result = await _taxistaService.
    updateUrlImagen(documentID: documentID, urlImagen: urlImagen);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar urlImagen');
    }

  }

  Future reautenticate(
    String password
  ) async {
    var result = await _authService.reautenticate(password);

    if (result is String) {
      print('Error al reautenticar '+ result);
    } else {
      print('Se reautentico con exito');
    }

  }

  Future updateCorreoUser({
      @required String email,
  }) async {
    
    var result = await _authService.updateEmail(email: email);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar correo');
    }

  }

  Future updateCorreoTaxista({
      @required String email,
      @required String documentID,
  }) async {
    
    var result = await _taxistaService.
    updateCorreo(documentID: documentID, email: email);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar correo');
    }

  }

  Future updatePasswordTaxista({
      @required String password,
  }) async {
    
    var result = await _authService.updatePassword(password: password);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar password');
    }

  }

  Future updateCiudad({
      @required String ciudad,
      @required String documentID,
  }) async {
    var result = await _taxistaService.
    updateCiudad(documentID: documentID, ciudad: ciudad);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar ciudad');
    }

  }

  Future updateUbicacionGPS({
    @required String documentID,
    @required double latitude,
    @required double longitude,
  }) async {
    var result = await _taxistaService.
    updateUbicacion(documentID: documentID, latitude: latitude, longitude: longitude);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar ubicacion');
    }

  }

}