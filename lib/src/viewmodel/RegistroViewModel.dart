import 'package:flutter/cupertino.dart';
import '../services/AuthService.dart';
import '../models/Taxista.dart';
import '../services/TaxistaService.dart';

class RegistroViewModel {

  AuthService _authService = new AuthService();
  TaxistaService _taxistaService = new TaxistaService();

  //registrar usuario en firebase
  Future singUp({
    @required String email,
    @required String password,
    @required Taxista taxista
  }) async {
      dynamic result = await _authService.signUpWithEmail(email: email, password: password);
      if (result is bool) {
        if (result) {
          print('registro exitoso');
          addTaxista(taxista);
        } else {
          print('registro fallo, intente de nuevo');
        }
      } else {
        print('registro fallor un error' + result);
      }
  }

  //crear taxista 
  Future addTaxista(Taxista taxista) async {
    print('enviando taxista a direbase');
    dynamic result = await _taxistaService.addTaxista(taxista);
    if (result is String) {
      print('No se pudo registrar el taxista');
    } else {
      print('Taxista registrado');
    }

  }

}