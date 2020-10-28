class Taxista {
  String nombre;
  String telefono;
  String cedula;
  String email;
  String ciudad;
  String documentId;
  bool estado;
  String urlImagen;
  Map auto;
  Map ubicacionGPS;
  

  Taxista({
    this.nombre,
    this.cedula,
    this.telefono,
    this.email,
    this.ciudad,
    this.estado,
    this.urlImagen,
    this.auto,
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
    'auto': auto,
    'ubicacionGPS': ubicacionGPS,
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
        auto = {
          'marca' : json['auto']['marca'],
          'modelo' : json['auto']['modelo'],
          'placa' : json['auto']['placa'],
        },
        ubicacionGPS = {
          'latitude' : json['ubicacionGPS']['latitude'] != null ? json['ubicacionGPS']['latitude'] : '',
          'longitude' : json['ubicacionGPS']['longitude'] != null ? json['ubicacionGPS']['longitude'] : '',
        };

}