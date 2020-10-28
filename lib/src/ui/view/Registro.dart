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
  
  _registrarUsuario() async {
    print(taxista.nombre);
    taxista.estado = false;
    taxista.auto = {
      'marca' : '',
      'modelo' : '',
      'placa' : '',
    };
    taxista.ubicacionGPS = {
      'latitude' : '',
      'longitude' : '',
    };

    dynamic result = await _registroViewModel
    .singUp(
      email: userAut.email.trim(), 
      password: userAut.password, 
      taxista: taxista);

    if (result is bool) {
      if (result) {
        //eliminar todas las rutas anteriores de la pila para que no se pueda regresar a ellas
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/dashboard', (Route<dynamic> route) => false);
      } else {
        mostrarError(
            'Ocurrio un error al registrarse, intentelo nuevamente por favor');
      }
    } else {
      if (result == 'email-already-in-use') mostrarError('El correo ingresado ya existe, revise su información por favor.');
    }

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
    var screenSize = MediaQuery.of(context).size;
    return Stack(alignment: const Alignment(0.6, 0.6), children: [
      LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            colors: [
                          Colors.orange[900],
                          Colors.orange[800],
                          Colors.orange[400]
                        ])),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                //color: Colors.green
                                ),
                            height: screenSize.height * 0.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Registrarse',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: <Widget>[
                                        
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromRGBO(
                                                      255, 95, 27, .3),
                                                  blurRadius: 20,
                                                  offset: Offset(0, 10))
                                            ]),
                                            child: Column(
                                                children: <Widget>[

                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: styleBoxContainer(),
                                                    child: TextFormField(
                                                      textCapitalization:
                                                          TextCapitalization.words,
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
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: styleBoxContainer(),
                                                    child: TextFormField(
                                                      decoration: styleInput('Cédula'),
                                                      keyboardType: TextInputType.number,
                                                      validator: (String value) {
                                                        if (value.isEmpty) {
                                                          return 'Cédula requerida';
                                                        }
                                                        if (value.length < 10 ||
                                                            value.length > 10) {
                                                          return 'Cédula invalida, debe tener 10 digitos';
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (String value) {
                                                        taxista.cedula = value;
                                                      },
                                                      style: getStylesTextInput(),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: styleBoxContainer(),
                                                    child: TextFormField(
                                                      decoration: styleInput(
                                                          'Correo electrónico'),
                                                      keyboardType:
                                                          TextInputType.emailAddress,
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
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: styleBoxContainer(),
                                                    child: TextFormField(
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
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: styleBoxContainer(),
                                                    child: TextFormField(
                                                      decoration:
                                                          styleInput('Contraseña'),
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
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: styleBoxContainer(),
                                                    child: TextFormField(
                                                      decoration: styleInput(
                                                          'Repita la Contraseña'),
                                                      validator: (String value) {
                                                        if (value.isEmpty) {
                                                          return 'Confirmar contraseña';
                                                        }
                                                        if (userAut.password != null &&
                                                            value != userAut.password) {
                                                          //print(usuario.password);
                                                          //print(value);
                                                          return 'La contraseña no coincide';
                                                        }
                                                        return null;
                                                      },
                                                      style: getStylesTextInput(),
                                                      obscureText: true,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: styleBoxContainer(),
                                                    child: TextFormField(
                                                      controller: ciudadTextController,
                                                      decoration: InputDecoration(
                                                        hintText: 'Ciudad',
                                                        //border: InputBorder.none,
                                                        suffixIcon:
                                                            Icon(Icons.expand_more),
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
                                                  ),
                                                ]
                                              )
                                        )
                                      ]
                                    )
                                  )
                                )
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Enviando datos')));
                                _formKey.currentState.save();
                                _registrarUsuario();
                              }
                            },
                            child: Container(
                              height: 50,
                              margin:
                                  EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(50),
                                  color: Colors.orange[900]),
                              child: Center(
                                child: Text(
                                  'Registrarse',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )));
      })
    ]);
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
          title: Text("Ciudades disponibles",
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal
            ),
          ),
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
        //labelText: placeholder,
        hintText: placeholder,
        hintStyle: TextStyle(color: Colors.grey),
        //border: InputBorder.none,
      );
  }

  BoxDecoration styleBoxContainer() {
    return BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200])));
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