class Oferta {
  String idTaxi;
  double tarifa;
  String distancia;
  int tiempo;
  bool mostrar;
  String idSolicitud;
  String documentoID;
  bool aceptada;
  bool rechazada;

  Oferta({
    this.idTaxi,
    this.documentoID,
    this.idSolicitud,
    this.distancia,
    this.tarifa,
    this.tiempo,
    this.mostrar,
    this.aceptada,
    this.rechazada
  });

  Map<String, dynamic> toMap() => {
    'idTaxi' : idTaxi,
    'idSolicitud' : idSolicitud,
    'tarifa' : tarifa,
    'distancia' : distancia,
    'tiempo' : tiempo,
    'mostrar' : mostrar,
    'aceptada' : aceptada,
    'rechazada' : rechazada,
  };

   Oferta.fromJson(Map<String, dynamic> json, String documentoID)
      : documentoID = documentoID,
        idTaxi = json['idTaxi'],
        idSolicitud = json['idSolicitud'],
        tarifa = json['tarifa'],
        distancia = json['distancia'],
        tiempo = json['tiempo'],
        mostrar = json['mostrar'],
        aceptada = json['aceptada'],
        rechazada = json['rechazada'];

}