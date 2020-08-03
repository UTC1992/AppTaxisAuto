import 'package:flutter/material.dart';
import '../screens/CiudadScreen.dart';
import '../screens/ViajesScreen.dart';

class DrawerNavigation extends StatefulWidget {
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerNavigation> {

  int _selectDrawerItem = 0;

  _getDrawerItemWidget(int posicion) {
    switch(posicion) {
      case 0 : 
        return CiudadScreen();
      case 1 :
        return ViajesScreen();
    }
  }

  _getTituloHeader() {
    switch(_selectDrawerItem) {
      case 0 : return 'Ciudad';
      case 1 : return 'Viajes';
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
              title: Text('Ciudad'),
              leading: Icon(Icons.location_city),
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
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectDrawerItem),
    );
  }
}
