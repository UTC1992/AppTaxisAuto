import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../viewmodel/TaxistaViewModel.dart';
import '../../../models/Taxista.dart';
import 'package:validators/validators.dart' as validator;

class EditarCorreo extends StatefulWidget {
  final Taxista data;

  EditarCorreo({
    Key key,
    @required this.data,
  }) : super(key: key);

  _EditarCorreoState createState() => _EditarCorreoState();
}

class _EditarCorreoState extends State<EditarCorreo> {
  
  final _formKey = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  String email;
  String documentID;
  String password;

  @override
  void initState() {
    super.initState(); 
    documentID = widget.data.documentId;
    _getEmailTaxista();
  }

  _getEmailTaxista() async {
    FirebaseUser user = await _taxistaViewModel.getTaxistaLogeado();
    setState(() {
      email = user.email;
    });
  }

  _updateCorreoTaxista() {
    print('password => ' + password);
    _taxistaViewModel.reautenticate(password).then((value){
      _taxistaViewModel.updateCorreoUser(email: email.trim());
      _taxistaViewModel.updateCorreoTaxista(email: email.trim(), documentID: documentID);
      Navigator.pop(context);
    })
    .catchError((error){
      print(error);
    });
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar correo'),
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
                  child: Text('CORREO DEL USUARIO'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric( horizontal: 20),
                  child: TextFormField(
                    controller: TextEditingController(text: email+' '),
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      
                      if(value.isEmpty) {
                        return 'Correo requerido.';
                      }

                      if (!validator.isEmail(value.trim())) {
                        return 'Correo invalido';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if(_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      //_updateCorreoTaxista();
                      _ingresarPassword();
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

  _ingresarPassword() {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ingrese la contraseña'),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0)), //this right here
        content: Form(
          key: _formKeyPass,
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Contraseña'),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Contraseña requerida';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                    obscureText: true,
                  ),
                  
                ],
              ),
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: 320.0,
            child: RaisedButton(
              onPressed: () {
                if(_formKeyPass.currentState.validate()) {
                  _formKeyPass.currentState.save();
                  _updateCorreoTaxista();
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Actualizar correo",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              color: const Color(0xFF1BC0C5),
            ),
          ),
        ],

      );
    });
  }

}
