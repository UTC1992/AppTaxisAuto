class Taxista {
  String nombre;
  String cedula;
  String email;
  String ciudad;
  String password;
  String documentId;

  Taxista({
    this.nombre,
    this.cedula,
    this.email,
    this.ciudad,
    });

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'cedula': cedula,
    'email': email,
    'ciudad': ciudad,
  };

  Map<String, dynamic> toMapNombre() => {
    'nombre': nombre,
  };

  Taxista.fromJson(Map<String, dynamic> json)
      : nombre = json['nombre'],
        email = json['email'],
        cedula = json['cedula'],
        ciudad = json['ciudad'];

}