import '../services/AuthFirebase.dart';

class LoginMV {

  AuthFirebase _authFirebase = new AuthFirebase();

  iniciarSesion (email, password) {
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

}