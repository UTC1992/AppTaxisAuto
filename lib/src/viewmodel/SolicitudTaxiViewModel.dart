import 'package:flutter/cupertino.dart';
import '../services/AuthService.dart';
import '../services/SolicitudTaxiService.dart';
import '../models/Oferta.dart';

class SolicitudTaxiViewModel extends AuthService{

  final SolicitudTaxiService _solicitudTaxiService = SolicitudTaxiService();
  
  Future getClienteByID(String id) async {
    var result = await _solicitudTaxiService.getClienteByID(id);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      
      return result;
    } 
    
  }

  Future getRatingCliente(String id) async {
    var result = await _solicitudTaxiService.getRatingCliente(id);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      
      return result;
    } 
    
  }

  Future addOferta({
      @required String documentID,
      @required Oferta oferta
  }) async {
    var result = await _solicitudTaxiService.
    addOferta(documentID: documentID, oferta: oferta);

    if (result is String) {
      print('Error al añadir oferta ' + result);
    } else {
      print('Exito al añadir oferta');
      Oferta ofertaAux = result; 
      print(ofertaAux.documentoID);
      return result;
    }

  }

  Future updateEstado({
      @required int estado,
      @required String documentID,
  }) async {
    var result = await _solicitudTaxiService.
    updateSolicitudEstado(documentID: documentID, estado: estado);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar estado');
    }

  }

  Future finalizarPedido({
      @required String documentID,
  }) async {
    var result = await _solicitudTaxiService.
    finalizarPedido(documentID: documentID);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar estado');
    }

  }

  Future cancelarSolicitud({
    @required String documentoID
  }) async {
    var result =
        await _solicitudTaxiService.cancelarPedido(documentID: documentoID);
    if (result is String) {
      print('error => ' + result);
    } else {
      print('Se cancelo la solicitud');
    }
  }

}