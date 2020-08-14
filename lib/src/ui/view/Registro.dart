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
  
  _registrarUsuario () {
    print(taxista.nombre);
    _registroViewModel.singUp(email: userAut.email, password: userAut.password, taxista: taxista);
    Navigator.pop(context);
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
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Cédula requerida';
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

  InputDecoration styleInput(placeholder) {
    return InputDecoration(labelText: placeholder, hintText: placeholder);
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