class Oferta {
  String idTaxi;
  double tarifa;
  double distancia;
  int tiempo;
  bool mostrar;

  Map<String, dynamic> toMap() => {
    'idTaxi' : idTaxi,
    'tarifa' : tarifa,
    'distancia' : distancia,
    'tiempo' : tiempo,
    'mostrar' : mostrar,
  };

}