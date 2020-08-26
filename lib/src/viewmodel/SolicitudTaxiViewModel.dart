import '../services/SolicitudTaxiService.dart';
import '../models/SolicitudTaxi.dart';

class SolicitudTaxiViewModel {

  final SolicitudTaxiService _solicitudTaxiService = SolicitudTaxiService();

  //crear Cliente 
  Future addSolicitud(SolicitudTaxi solicitud) async {
    print('enviando Cliente a direbase');
    dynamic result = await _solicitudTaxiService.addSolicitudTaxi(solicitud);
    if (result is String) {
      print('No se pudo registrar la solicitud');
    } else {
      print('Solicitud registrada');
    }

  }
}