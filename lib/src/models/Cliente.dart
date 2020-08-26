class Cliente {
  String nombre;
  String telefono;
  String cedula;
  String email;
  String ciudad;
  String documentId;
  bool estado;
  String urlImagen;

  Cliente({
    this.nombre,
    this.cedula,
    this.telefono,
    this.email,
    this.ciudad,
    this.estado,
    this.urlImagen,
    });

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'cedula': cedula,
    'email': email,
    'telefono' : telefono,
    'ciudad': ciudad,
    'estado': estado,
    'urlImagen':'',
  };

  Cliente.fromJson(Map<String, dynamic> json)
      : documentId = json['id'], 
        nombre = json['nombre'],
        email = json['email'],
        cedula = json['cedula'],
        ciudad = json['ciudad'],
        telefono = json['telefono'],
        estado = json['estado'],
        urlImagen = json['urlImagen'];

}