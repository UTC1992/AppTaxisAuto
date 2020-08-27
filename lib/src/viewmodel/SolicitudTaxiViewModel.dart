import 'package:AppTaxisAuto/src/models/Cliente.dart';

import '../services/AuthService.dart';
import '../services/SolicitudTaxiService.dart';

class SolicitudTaxiViewModel extends AuthService{

  final SolicitudTaxiService _solicitudTaxiService = SolicitudTaxiService();
  
  Future getClienteByID(String id) async {
    var result = await _solicitudTaxiService.getClienteByID(id);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      
      return result;
    } 
    
  }

  Future getRatingCliente(String id) async {
    var result = await _solicitudTaxiService.getRatingCliente(id);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      
      return result;
    } 
    
  }

}