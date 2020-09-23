import 'dart:async';
import 'dart:convert';
import 'package:AppTaxisAuto/src/services/AuthService.dart';
import 'package:AppTaxisAuto/src/services/TaxistaService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PushNotificationProvider with ChangeNotifier {
  // Replace with server token from firebase console settings.
  final String serverToken = 'AAAASVqHKVk:APA91bEdYk3jbqJTE_JY7euLv8V8onAP1WIbpE5UEntzGco5nsYasVTTm4ESkZkW40LE-ob9-biU6qLcIZJ8-LgcFqWUw7qC5NJYzfMzu2qsxaFPxjs0GtpNC8jlzrn-DKrUtZeFC1yq';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TaxistaService _taxistaService = TaxistaService();
  final AuthService _authService = AuthService();

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    updateToken();

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

  Future updateToken() async {

    _firebaseMessaging.getToken().then((token) async {
      if(token != null) {
        print('==== FCM Token ====');
        print(token);
        User userLogin = await _authService.currentUser();

        if(userLogin != null) {
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
      
    });

    

  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    /*await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    */
    print('ENVIANDO NOTIFICACION');

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'this is a body',
          'title': 'this is a title'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': await _firebaseMessaging.getToken(),
      },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
  
}
