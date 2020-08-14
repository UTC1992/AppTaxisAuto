import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a getter stream
  Stream<FirebaseUser> get onAuthStateChanged => _auth.onAuthStateChanged;

  Future<FirebaseUser> get currentUser async {
    return await _auth.currentUser();
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

  

}
