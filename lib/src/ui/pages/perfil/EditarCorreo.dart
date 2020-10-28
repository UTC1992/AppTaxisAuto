import 'package:AppTaxisAuto/src/ui/widgets/botones/BtnAceptar.dart';
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
    User user = await _taxistaViewModel.getTaxistaLogeado();
    setState(() {
      email = user.email;
    });
  }

  _updateCorreoTaxista() async {
    print('password => ' + password);
    dynamic result = await _taxistaViewModel.reautenticate(password);

    if (result is bool) {
      if (result) {
        await _taxistaViewModel.updateCorreoUser(email: email.trim());
        await _taxistaViewModel.updateCorreoTaxista(email: email.trim(), documentID: documentID);
        Navigator.pop(context);
      } else {
        print('no se pedo actualizar el correo');
      }

    } else {
      if (result == 'wrong-password') mostrarError('Contraseña incorrecta');
    }
    
    
  }

  void mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var screenSize = MediaQuery.of(context).size;
        // return object of type Dialog
        return AlertDialog(
          actions: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Text(
                mensaje,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: screenSize.width,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
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
                    controller: TextEditingController(text: email != null ? email+'':''),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: BtnAceptar(
                    activo: true,
                    onPress: () {
                      if(_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        //_updateCorreoCliente();
                        _ingresarPassword();
                      }
                    },
                    titulo: 'Actualizar',
                    alto: 45,
                  ),
                ),
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
       var screenSize = MediaQuery.of(context).size;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ), 
        child: Container(
          height: screenSize.height * 0.4,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('Ingrese la contraseña', 
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 18
                  ),
                ),
                Form(
                  key: _formKeyPass,
                  child: Container(
                    height: screenSize.height * 0.20,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(
                              fontSize: 16
                            ),
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

                GestureDetector(
                  onTap: () {
                    if(_formKeyPass.currentState.validate()) {
                      _formKeyPass.currentState.save();
                      _updateCorreoTaxista();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: screenSize.width * 0.4,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Text(
                      "Actualizar",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ),
        
              ],
            ),
          ),
        ),
      );
    });
  }

}
