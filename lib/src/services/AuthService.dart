import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a getter stream
  Stream<User> get onAuthStateChanged => _auth.authStateChanges();

  Future currentUser() async {
    try {
      User user = _auth.currentUser;
      return user;
    } catch (e) {
      return e.toString();
    }
    
  }

  Future loginWithEmail({
      @required String email,
      @required String password,
  }) async {
      try {
          var user = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          notifyListeners();
          return user != null;
      } catch (e) {
          return e.code;
      }
  }

  Future signUpWithEmail({
      @required String email,
      @required String password,
  }) async {
      try {
          var authResult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          notifyListeners();
          return authResult.user != null;
      } catch (e) {
          return e.code;
      }
  }

  Future reautenticate(
    password,
  ) async {
    try {
      User user = _auth.currentUser;
      UserCredential authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email,
          password: password
        ));
      return authResult;
    } catch (e) {
      return e.code;
    }
    
  }

  Future updateEmail({
      @required String email,
  }) async {
      try {
        User user = _auth.currentUser;
        var result = await user.updateEmail(email);
        notifyListeners();
        return result;
      } catch (e) {
          return e.toString();
      }
  }

  Future updatePassword({
      @required String password,
  }) async {
      try {
        User user = _auth.currentUser;
        var result = await user.updatePassword(password);
        notifyListeners();
        return result;
      } catch (e) {
          return e.toString();
      }
  }

  Future cerrarSesion() async {
    try {
      await _auth.signOut();
      notifyListeners();
      return true;
    } catch (e) {
      return e.toString();
    }
    
  }

}
