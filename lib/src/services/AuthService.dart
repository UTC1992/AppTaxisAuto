import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a getter stream
  Stream<FirebaseUser> get onAuthStateChanged => _auth.onAuthStateChanged;

  Future currentUser() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      return user;
    } catch (e) {
      return e.toString();
    }
    
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
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
          return e.message;
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
          return e.message;
      }
  }

  Future reautenticate(
    password,
  ) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      AuthResult authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.getCredential(
          email: user.email,
          password: password
        ));
      return authResult;
    } catch (e) {
      return e.toString();
    }
    
  }

  Future updateEmail({
      @required String email,
  }) async {
      try {
        FirebaseUser user = await _auth.currentUser();
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
        FirebaseUser user = await _auth.currentUser();
        var result = await user.updatePassword(password);
        notifyListeners();
        return result;
      } catch (e) {
          return e.toString();
      }
  }

}
