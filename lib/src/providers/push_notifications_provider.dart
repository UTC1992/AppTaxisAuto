import 'package:AppTaxisAuto/src/services/AuthService.dart';
import 'package:AppTaxisAuto/src/services/TaxistaService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class PushNotificationProvider with ChangeNotifier {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TaxistaService _taxistaService = TaxistaService();
  final AuthService _authService = AuthService();

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.getToken().then((token) {
      if(token != null) {
        print('==== FCM Token ====');
        print(token);
        updateToken(token);
      }
      
    });

    _firebaseMessaging.configure(
      onBackgroundMessage: mensajeEnSegundoPlano,
      onMessage: (info) {
        print('===== ON Message =====');
        print(info);
      },
      onLaunch: (info) {
        print('===== ON Launche =====');
        print(info);
      }, onResume: (info) {
        print('===== ON Resume =====');
        print(info);
      }
    );

  }

  addNotificacionOfertas() {
    
  }

  static Future<dynamic> mensajeEnSegundoPlano(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future updateToken(String token ) async {

    User userLogin = await _authService.currentUser();

    QuerySnapshot documents = await _taxistaService.getIdDocument(userLogin.email);

    var idCliente;

    documents.docs.forEach((doc) {
      idCliente = doc.id;
    });

    var result = await _taxistaService.
    updateToken(documentID: idCliente, token: token);

    if (result is String) {
      print('Error al actualizar ' + result);
    } else {
      print('Exito al actualizar token');
    }

  }
  
}
