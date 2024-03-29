import 'package:AppTaxisAuto/src/ui/widgets/botones/BtnAceptar.dart';
import 'package:flutter/material.dart';
import '../../../viewmodel/TaxistaViewModel.dart';

class EditarPassword extends StatefulWidget {
  _EditarPasswordState createState() => _EditarPasswordState();
}

class _EditarPasswordState extends State<EditarPassword> {
  final _formKey = GlobalKey<FormState>();
  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();

  String passwordAnterior;
  String passwordNueva;
  String email;

  @override
  void initState() {
    super.initState();
  }

  _updatePassword() {
    print('password => ' + passwordAnterior);
    _taxistaViewModel.reautenticate(passwordAnterior).then((value) {
      _taxistaViewModel.updatePasswordTaxista(password: passwordNueva);
      Navigator.pop(context);
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar contraseña'),
      ),
      body: getContainer(),
    );
  }

  Widget getContainer() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('CONTRASEÑA ANTERIOR'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: TextEditingController(text: ''),
                      autofocus: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Contraseña requerida.';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        passwordAnterior = value;
                      },
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('CONTRASEÑA NUEVA'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: TextEditingController(text: ''),
                      autofocus: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Confirmar contraseña.';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        passwordNueva = value;
                      },
                      obscureText: true,
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
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _updatePassword();
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
      ),
    );
  }
}
