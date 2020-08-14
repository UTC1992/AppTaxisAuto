import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/TaxistaService.dart';
import '../services/AuthService.dart';
import '../models/Taxista.dart';

class TaxistaViewModel {
  final TaxistaService _taxistaService = TaxistaService();
  final AuthService _authService = AuthService();

  Future getUserLogeado() async {
    FirebaseUser result = await _authService.currentUser();
    if (result is String) {
      print('no se puedo obtener el usuario');
      return false;
    } else {
      //print(result.email);
      getTaxistaByEmail(result.email);
    }
  }

  Future getTaxistaByEmail(String email) async {
    var result = await _taxistaService.getTaxistaByEmail(email);

    if (result is String) {
      print('No se pudo registrar el taxista');
    } else {
       Taxista user = new Taxista.fromJson(result);
      print(user.cedula);
    }

  }


}