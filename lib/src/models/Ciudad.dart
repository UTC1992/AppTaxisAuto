class Ciudad {
  String nombre;
  String documentID;

  Ciudad({
    this.nombre,
    this.documentID
  });

  Ciudad.fromJson(Map<String, dynamic> json)
    : documentID = json['id'], 
      nombre = json['nombre'];
}