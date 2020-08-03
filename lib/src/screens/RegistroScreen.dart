import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                TextFormField(
                  decoration: styleInput('Nombre'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Nombre requerido';
                    }
                  },
                  style: getStylesTextInput(),
                ),
                TextFormField(
                  decoration: styleInput('Cédula'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Cédula requerida';
                    }
                  },
                  style: getStylesTextInput(),
                ),
                TextFormField(
                  decoration: styleInput('Correo electrónico'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Correo requerido';
                    }
                  },
                  style: getStylesTextInput(),
                ),
                TextFormField(
                  decoration: styleInput('Contraseña'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Contraseña requerida';
                    }
                  },
                  style: getStylesTextInput(),
                  obscureText: true,
                ),
                TextFormField(
                  decoration: styleInput('Repita la Contraseña'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Contraseña requerida';
                    }
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
                            SnackBar(content: Text('Procesando datos')));
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