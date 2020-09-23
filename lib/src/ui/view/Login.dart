import 'package:AppTaxisAuto/src/providers/push_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/LoginViewModel.dart';
import '../../models/UserAutenticacion.dart';
import 'package:validators/validators.dart' as validator;

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FormLogin(),
      ),
    );
  }
}

class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() {
    return _FormLoginState();
  }
}

class _FormLoginState extends State<FormLogin> {
  
  final _formKey = GlobalKey<FormState>();
  UserAutenticacion userAuth = UserAutenticacion();

  LoginViewModel _loginViewModel = LoginViewModel();

  _iniciarSesion () {
    _loginViewModel.login(email: userAuth.email, password: userAuth.password);
    
    PushNotificationProvider notificaciones = Provider.of<PushNotificationProvider>(context, listen: false);
    notificaciones.updateToken();

    //eliminar todas las rutas anteriores de la pila para que no se pueda regresar a ellas
    Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', 
    (Route<dynamic> route) => false);
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60),
                                  topRight: Radius.circular(60),
                                  bottomLeft: Radius.circular(60),
                                  bottomRight: Radius.circular(60),
                                  )),
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(255, 95, 27, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]))),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: 'Correo electrónico',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Correo requerido';
                                            }
                                            if (!validator.isEmail(value)) {
                                              return 'Correo invalido';
                                            }
                                            return null;
                                          },
                                          onChanged: (String value) => userAuth.email = value,
                                          keyboardType: TextInputType.emailAddress,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]))),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: 'Contraseña',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Contraseña requerida';
                                            }
                                            if (value.length < 8) {
                                              return 'Ingrese un minimo de 8 caracteres';
                                            }
                                            return null;
                                          },
                                          onChanged: (String value) => userAuth.password = value,
                                          obscureText: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '¿ Olvido la contraseña ? ',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      _iniciarSesion();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.orange[900]),
                                    child: Center(
                                      child: Text(
                                        'Iniciar sesión',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                      ]),
                ),
              ),
            ),
          );
        })
      ],
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
