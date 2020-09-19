
import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitudTaxi {
  String clienteID;
  String origenDireccion;
  Map origenGPS;
  String destinoDireccion;
  Map destinoGPS;
  double tarifa;
  String comentario;
  String documentID;
  bool cancelada;
  String idTaxista;
  bool finalizada;
  int estado;
  Timestamp fechaCreacion;
  Timestamp fechaOrdenar;

  SolicitudTaxi({
    this.clienteID,
    this.origenDireccion,
    this.origenGPS,
    this.destinoDireccion,
    this.destinoGPS,
    this.tarifa,
    this.comentario,
    this.documentID,
    this.cancelada,
    this.idTaxista,
    this.finalizada,
    this.estado,
    this.fechaCreacion,
    this.fechaOrdenar
  });

  Map<String, dynamic> toMap() => {
    'idCliente': clienteID,
    'origenDireccion': origenDireccion,
    'origenGPS': {
      'latitude' : origenGPS['latitude'],
      'longitude' :  origenGPS['longitude'],
    },
    'destinoDireccion': destinoDireccion,
    'destinoGPS' : {
      'latitude' : destinoGPS['latitude'],
      'longitude' :  destinoGPS['longitude'],
    },
    'tarifa': tarifa,
    'comentario': comentario,
    'cancelada': cancelada,
    'idTaxista': idTaxista,
    'finalizada': finalizada,
    'estado': estado,
    'fechaCreacion': fechaCreacion,
    'fechaOrdenar': fechaOrdenar
  };

   SolicitudTaxi.fromJson(Map<String, dynamic> json, String documentoID)
      : documentID = documentoID,
        clienteID = json['idCliente'], 
        origenDireccion = json['origenDireccion'],
        origenGPS = {
          'latitude' : json['origenGPS']['latitude'],
          'longitude' : json['origenGPS']['longitude'],
        },
        destinoDireccion = json['destinoDireccion'],
        destinoGPS = {
          'latitude' : json['destinoGPS']['latitude'],
          'longitude' : json['destinoGPS']['longitude'],
        },
        tarifa = json['tarifa'],
        comentario = json['comentario'],
        cancelada = json['cancelada'],
        idTaxista = json['idTaxista'],
        finalizada = json['finalizada'],
        estado = json['estado'],
        fechaCreacion = json['fechaCreacion'],
        fechaOrdenar = json['fechaOrdenar'];

}