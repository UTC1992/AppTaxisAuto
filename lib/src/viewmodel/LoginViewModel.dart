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
        return true;
      } else {
        print('falio el login intente nuevamenrte');
        return false;
      }
    } else {
      print('Fallo el login error ' + result);
      return result;
    }
  }
  
}