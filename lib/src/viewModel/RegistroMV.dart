import '../services/AuthFirebase.dart';

class RegistroMV {

  AuthFirebase _authFirebase = new AuthFirebase();

  registrarUsuario (email, password) {
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