import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../viewmodel/TaxistaViewModel.dart';

class EditarNombre extends StatefulWidget {
  _EditarNombreState createState() => _EditarNombreState();
}

class _EditarNombreState extends State<EditarNombre> {
  
  final _formKey = GlobalKey<FormState>();
  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  FirebaseUser user;

  _getUsuarioLogeado () async {
    print('Obtener usuario.............');
    _taxistaViewModel.getUserLogeado();
  }

  @override
  void initState() {
    super.initState();
    _getUsuarioLogeado();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar nombre y apellido'),
      ),
      body: getContainer(),
    );
  }

  Widget getContainer() {
    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('NOMBRE Y APELLIDO'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric( horizontal: 20),
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Debe ingresar su nombre y apellido';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if(_formKey.currentState.validate()) {

                    }
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Actualizar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
