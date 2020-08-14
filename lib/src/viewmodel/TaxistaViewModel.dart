import '../services/TaxistaService.dart';
import '../models/Taxista.dart';

class TaxistaViewModel {
  final TaxistaService _taxistaService = TaxistaService();

  Future addPost(Taxista taxista) async {
    dynamic result = await _taxistaService.addTaxista(taxista);

    if (result is String) {
      print('No se pudo registrar el taxista');
    } else {
      print('Taxista registrado');
    }

  }

}