
import '../services/AuthFirebase.dart';

class AutenticacionUserVM {

  AuthFirebase _authFirebase = new AuthFirebase();

  bool estaLogeado (email, password) {
    _authFirebase.handleSignIn(email, password)
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