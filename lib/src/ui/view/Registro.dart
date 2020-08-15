import 'package:AppTaxisAuto/src/models/Ciudad.dart';
import 'package:flutter/material.dart';
import '../../models/Taxista.dart';
import '../../models/UserAutenticacion.dart';
import 'package:validators/validators.dart' as validator;
import '../../viewmodel/RegistroViewModel.dart';

class Registro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Center(
        child: FormRegistro(),
      ),
    );
  }
}

class FormRegistro extends StatefulWidget {
  @override
  _FormRegistroState createState() {
    return _FormRegistroState();
  }
}

class _FormRegistroState extends State<FormRegistro> {

  final _formKey = GlobalKey<FormState>();
  Taxista taxista = Taxista();
  UserAutenticacion userAut = UserAutenticacion();
  RegistroViewModel _registroViewModel = RegistroViewModel();
  var ciudades = new List<Ciudad>();
  final ciudadTextController = TextEditingController();
  
  _registrarUsuario() {
    print(taxista.nombre);
    taxista.estado = false;
    _registroViewModel.singUp(email: userAut.email.trim(), password: userAut.password, taxista: taxista);
    Navigator.pop(context);
  }

  _getCiudades() async {
    ciudades = await _registroViewModel.getCiudades();
    print(ciudades[0].nombre);
  }

  @override
  void initState() {
    super.initState();
    _getCiudades();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    ciudadTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: styleInput('Nombre'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Nombre requerido';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    taxista.nombre = value;
                  },
                  style: getStylesTextInput(),
                ),
                TextFormField(
                  decoration: styleInput('Cédula'),
                  keyboardType: TextInputType.number,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Cédula requerida';
                    }
                    if (value.length < 10 || value.length > 10) {
                      return 'Cédula invalida, debe tener 10 digitos';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    taxista.cedula = value;
                  },
                  style: getStylesTextInput(),
                ),
                TextFormField(
                  decoration: styleInput('Correo electrónico'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Correo requerido';
                    }
                    if (!validator.isEmail(value)) {
                      return 'Correo invalido';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    taxista.email = value;
                    userAut.email = value;
                  },
                  style: getStylesTextInput(),
                ),
                TextFormField(
                  decoration: styleInput('Teléfono'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Teléfono requerido';
                    }
                    if (value.length < 10) {
                      return 'Teléfono invalido, debe tener 10 digitos';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    taxista.telefono = value;
                  },
                  style: getStylesTextInput(),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  decoration: styleInput('Contraseña'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Contraseña requerida';
                    }
                    if (value.length < 8) {
                      return 'Ingrese un minimo de 8 caracteres';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    userAut.password = value;
                  },
                  style: getStylesTextInput(),
                  obscureText: true,
                ),
                TextFormField(
                  decoration: styleInput('Repita la Contraseña'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Confirmar contraseña';
                    }
                    if (userAut.password != null && value != userAut.password) {
                      //print(usuario.password);
                      //print(value);
                      return 'La contraseña no coincide';
                    }
                    return null;
                  },
                  style: getStylesTextInput(),
                  obscureText: true,
                ),
                TextFormField(
                    controller: ciudadTextController,
                    decoration: InputDecoration(
                      hintText: 'Ciudad',
                      suffixIcon: Icon(Icons.expand_more),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Ciudad requerida';
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () {
                      _mostrarCiudades();
                    },
                    style: getStylesTextInput(),
                    
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Enviando datos')));
                        _formKey.currentState.save();
                       _registrarUsuario();
                       
                      }
                    },
                    child: Text(
                      'Registrarse',
                      style: getStylesBoton(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _asignarCiudad(nombre) {
    ciudadTextController.text = nombre; 
  }
  
  // user defined function
  void _mostrarCiudades() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Ciudades disponibles"),
          content: SingleChildScrollView(
          child: Container(
            width: 300,
            height: 200,
            child: ListView.builder(
              itemCount: ciudades.length,
              itemBuilder: (context, index) {
                return GestureDetector( 
                  onTap: () {
                    taxista.ciudad = ciudades[index].nombre;
                    _asignarCiudad(ciudades[index].nombre);
                    Navigator.of(context).pop();
                  },
                  child: ListTile(title: Text(ciudades[index].nombre),)
                );
              }
            ),
          ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok", style: TextStyle(fontSize: 16),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  InputDecoration styleInput(placeholder) {
    return InputDecoration(
      hintText: placeholder
      );
  }

  ///
  ///estilos para texto
  TextStyle getStylesTextInput() {
    return const TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontSize: 18.0,
    );
  }

  ///
  ///estilos para texto
  TextStyle getStylesBoton() {
    return const TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontSize: 18.0,
    );
  }



}

/* new Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/kukayodeliveryapp.appspot.com/o/9pNsaTgjXC5n7yqvAEih%2Fproductos%2F3ViU06FZ0mL7usJdQQl9.jpeg?alt=media&token=c2f20771-a47d-4a62-96fb-b2f7bc80fbc3',
                ),
 */