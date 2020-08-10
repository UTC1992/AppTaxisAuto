import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebase {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //iniciar sesion con email y contraseña
  Future<FirebaseUser> handleSignIn(email, password) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      )).user;
    print('ingreso con => ' + user.displayName);
    return user;
  }

}