import 'package:AppTaxisAuto/src/models/Taxista.dart';
import 'package:AppTaxisAuto/src/providers/push_notifications_provider.dart';
import 'package:AppTaxisAuto/src/viewmodel/TaxistaViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui/view/Perfil.dart';
import '../ui/view/Viajes.dart';
import '../ui/view/Solicitudes.dart';
import '../services/AuthService.dart';

class DrawerNavigation extends StatefulWidget {
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerNavigation> {

  AuthService authService = AuthService();
  int _selectDrawerItem = 0;

  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  Taxista taxista;

  _getUsuarioLogeado() async {
    print('Obtener usuario.............');
    User user = await _taxistaViewModel.getTaxistaLogeado();
    if (user != null && mounted) {
      _taxistaViewModel.getTaxistaByEmail(user.email).listen((event) {
        setState(() {
          taxista = event;
        });
       });
    }
    
  }

  _getDrawerItemWidget(int posicion) {
    switch(posicion) {
      case 0 : 
        return Solicitudes();
      case 1 :
        return Viajes();
      case 2 :
        return Perfil();
    }
  }

  _getTituloHeader() {
    switch(_selectDrawerItem) {
      case 0 : return 'Solicitudes';
      case 1 : return 'Viajes';
      case 2 : return 'Perfil';
    }
  }

  _onSelectItem(int posicion) {
    Navigator.pop(context);
    ///
    ///setState vuelve a repintar o renderizar los elementos de la pantalla
    setState(() {
      _selectDrawerItem = posicion;
    });
  }

  void confirmarCerrarSesion() {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        var screenSize = MediaQuery.of(context).size;
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas cerrar la sesión?'),
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.black
          ),
          actions:  <Widget>[
            Container(
              width: screenSize.width,
              padding: EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Text('Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[800],
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      cerrarSesion();
                    },
                    child: Container(
                      child: Text('Aceptar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        );
      },
    );
  
  }

  cerrarSesion() async {
    await authService.cerrarSesion();
    Navigator.of(context).pushNamedAndRemoveUntil('/bienvenida', 
    (Route<dynamic> route) => false);
  }

  obtenerToken() async {
    PushNotificationProvider notificaciones = Provider.of<PushNotificationProvider>(context, listen: false);
    await notificaciones.updateToken();
  }

  @override
  void initState() {

    obtenerToken();
    _getUsuarioLogeado();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTituloHeader()),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                taxista != null 
                ? taxista.nombre
                : 'Usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
              ),
              accountEmail: Text(
                taxista != null 
                ? taxista.email
                : '@',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
              ),
              currentAccountPicture: 
                taxista != null
                ? taxista.urlImagen != ''
                  ? CircleAvatar(
                      radius: 360.0,
                      backgroundImage: NetworkImage(taxista.urlImagen),
                      backgroundColor: Colors.transparent,
                    )
                  : CircleAvatar(
                    radius: 360.0,
                    backgroundColor: Colors.white54,
                    child:  taxista != null && taxista.nombre != '' 
                            ?  Text(
                                taxista.nombre[0].toUpperCase() 
                                + taxista.nombre[1].toUpperCase(),
                                style: TextStyle(fontSize: 30),)
                            : Text('Yo', style: TextStyle(fontSize: 30)),
                  )
                : null
            ),
            ListTile(
              title: Text(
                'Solicitudes',
                style: TextStyle(
                  fontSize: 16
                ),
                ),
              leading: Icon(Icons.view_list),
              selected: (0 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(0);
              },
            ),
            ListTile(
              title: Text('Viajes',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
              leading: Icon(Icons.airline_seat_recline_extra),
              selected: (1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(1);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Perfil',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
              leading: Icon(Icons.account_circle),
              selected: (2 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(2);
              },
            ),
            ListTile(
              title: Text('Cerrar sesión',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
              leading: Icon(Icons.close),
              selected: false,
              onTap: () {
                confirmarCerrarSesion();
              },
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectDrawerItem),
    );
  }
}
