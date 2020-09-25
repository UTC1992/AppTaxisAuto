import 'package:AppTaxisAuto/src/providers/push_notifications_provider.dart';
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
            fontSize: 25,
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
                          fontSize: 20,
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
                          fontSize: 20,
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
              accountName: Text('Omar Guanoluisa'),
              accountEmail: Text('omar@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.green[700],
                child: Text(
                  'OG',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            ListTile(
              title: Text('Solicitudes'),
              leading: Icon(Icons.view_list),
              selected: (0 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(0);
              },
            ),
            ListTile(
              title: Text('Viajes'),
              leading: Icon(Icons.airline_seat_recline_extra),
              selected: (1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(1);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Perfil'),
              leading: Icon(Icons.account_circle),
              selected: (2 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(2);
              },
            ),
            ListTile(
              title: Text('Cerrar sesión'),
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
