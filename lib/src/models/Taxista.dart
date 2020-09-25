class Taxista {
  String nombre;
  String telefono;
  String cedula;
  String email;
  String ciudad;
  String documentId;
  bool estado;
  String urlImagen;
  Map ubicacionGPS;

  Taxista({
    this.nombre,
    this.cedula,
    this.telefono,
    this.email,
    this.ciudad,
    this.estado,
    this.urlImagen,
    this.ubicacionGPS,
    });

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'cedula': cedula,
    'email': email,
    'telefono' : telefono,
    'ciudad': ciudad,
    'estado': estado,
    'urlImagen':'',
    'ubicacionGPS':[],
  };

  Taxista.fromJson(Map<String, dynamic> json, String documentoID)
      : documentId = documentoID, 
        nombre = json['nombre'],
        email = json['email'],
        cedula = json['cedula'],
        ciudad = json['ciudad'],
        telefono = json['telefono'],
        estado = json['estado'],
        urlImagen = json['urlImagen'],
        ubicacionGPS = {
          'latitude' : json['ubicacionGPS']['latitude'],
          'longitude' : json['ubicacionGPS']['longitude'],
        };

}