import '../services/AuthService.dart';
import '../services/SolicitudTaxiService.dart';
import '../models/SolicitudTaxi.dart';

class SolicitudTaxiViewModel extends AuthService{

  final SolicitudTaxiService _solicitudTaxiService = SolicitudTaxiService();
  
}