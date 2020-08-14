import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Taxista.dart';

class TaxistaService {
  final CollectionReference _collectionReference =
      Firestore.instance.collection('col_taxista');
  
  Future addTaxista(Taxista taxista) async {
    try {
      await _collectionReference.add(taxista.toMap());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

}
