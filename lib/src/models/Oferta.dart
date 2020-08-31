class Oferta {
  String idTaxi;
  double tarifa;
  String distancia;
  int tiempo;
  bool mostrar;
  String idSolicitud;

  Map<String, dynamic> toMap() => {
    'idTaxi' : idTaxi,
    'idSolicitud' : idSolicitud,
    'tarifa' : tarifa,
    'distancia' : distancia,
    'tiempo' : tiempo,
    'mostrar' : mostrar,
  };

}