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

  Future getTaxistaByEmail(String email) async {
    try {
      QuerySnapshot result = await _collectionReference
      .where('email', isEqualTo: email)
      .getDocuments();

      //convertir a objeto taxista
      var data;

      result.documents.forEach((res) {
        print(res.documentID);
        data = res.data;
      });
    
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateTaxista(Taxista taxista) async {
    try {
      await _collectionReference
      .document(taxista.documentId)
      .updateData(taxista.toMapNombre());

      return true;
    } catch (e) {
      return e.toString();
    }
  }

}
