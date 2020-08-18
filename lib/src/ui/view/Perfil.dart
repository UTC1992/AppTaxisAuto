import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../viewmodel/TaxistaViewModel.dart';
import '../../models/Taxista.dart';

class Perfil extends StatefulWidget {
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  Taxista taxista;
  bool _isVisible = false;

  _getUsuarioLogeado() async {
    print('Obtener usuario.............');
    FirebaseUser user = await _taxistaViewModel.getTaxistaLogeado();
    if (user != null) {
      _taxistaViewModel.getTaxistaByEmail(user.email).listen((event) {
        setState(() {
          taxista = event;
        });
       });

      setState(() {
        _isVisible = !_isVisible;
      });
    }
    
  }

  @override
  void initState() {
    _getUsuarioLogeado();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/editarNombre',
                          arguments: taxista);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.account_circle, color: Colors.grey[600]),
                        Expanded(
                          child: ListTile(
                            title: Text('Editar nombre'),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[500])
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/editarImagen',
                          arguments: taxista);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.photo, color: Colors.grey[600]),
                        Expanded(
                          child: ListTile(
                            title: Text('Editar imagen'),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[500],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/editarCorreo',
                          arguments: taxista);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.email, color: Colors.grey[600]),
                        Expanded(
                          child: ListTile(
                            title: Text('Editar correo'),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[500])
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/editarPassword');
                    },
                    child: Row(
                      children: [
                        Icon(Icons.lock, color: Colors.grey[600]),
                        Expanded(
                          child: ListTile(
                            title: Text('Editar contraseña'),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[500])
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                       Navigator.pushNamed(context, '/editarTelefono',
                          arguments: taxista);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey[600]),
                        Expanded(
                          child: ListTile(
                            title: Text('Editar teléfono'),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[500])
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                       Navigator.pushNamed(context, '/editarCiudad',
                          arguments: taxista);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.location_city, color: Colors.grey[600]),
                        Expanded(
                          child: ListTile(
                            title: Text('Editar ciudad'),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[500])
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
