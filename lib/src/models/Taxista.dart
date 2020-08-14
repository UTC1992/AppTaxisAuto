class Taxista {
  String nombre;
  String cedula;
  String email;
  String ciudad;
  String password;

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

}