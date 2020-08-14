import 'package:flutter/cupertino.dart';
import '../services/AuthService.dart';

class LoginViewModel {

  AuthService _authService = new AuthService();

  Future login({
    @required String email, 
    @required String password
  }) async {

    dynamic result = await _authService.loginWithEmail(
        email: email, password: password);

    if (result is bool) {
      if (result) {
        print('Se logeo correctamente');
      } else {
        print('falio el login intente nuevamenrte');
      }
    } else {
      print('Fallo el login error ' + result);
    }
  }
  
}