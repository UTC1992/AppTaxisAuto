import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthFirebase extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a getter stream
  Stream<FirebaseUser> get onAuthStateChanged => _auth.onAuthStateChanged;

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  //iniciar sesion con email y contraseña
  Future<FirebaseUser> iniciarSesion(email, password) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    print('ingreso con => ' + user.displayName);
    notifyListeners();
    return user;
  }

  //iniciar sesion con email y contraseña
  Future<FirebaseUser> registrarUsuario(email, password) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    print('ingreso con => ' + user.displayName);
    notifyListeners();
    return user;
  }

  Future<FirebaseUser> get currentUser async {
    return await _auth.currentUser();
  }

}
