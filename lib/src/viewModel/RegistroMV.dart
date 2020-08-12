import '../services/AuthFirebase.dart';

class RegistroMV {

  AuthFirebase _authFirebase = new AuthFirebase();

  bool iniciarSesion (email, password) {
    _authFirebase.iniciarSesion(email, password)
    .then((user) {
      if (user != null) {
        print(user.displayName);
        return true;
      } else {
        return false;
      }
    })
    .catchError((error) {
      print(error);
    });
  }

  bool registrarUsuario (email, password) {
    _authFirebase.registrarUsuario(email, password)
    .then((user) {
      if (user != null) {
        return true;
      } else {
        return false;
      }
    })
    .catchError((error) {
      print(error);
    });
  }

}