
class SolicitudTaxi {
  String clienteID;
  String origenDireccion;
  Map origenGPS;
  String destinoDireccion;
  Map destinoGPS;
  double tarifa;
  String comentario;

  SolicitudTaxi({
    this.clienteID,
    this.origenDireccion,
    this.origenGPS,
    this.destinoDireccion,
    this.destinoGPS,
    this.tarifa,
    this.comentario
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
    'comentario': comentario
  };

   SolicitudTaxi.fromJson(Map<String, dynamic> json)
      : clienteID = json['idCliente'], 
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
        comentario = json['comentario'];

}