import 'package:AppTaxisAuto/src/models/Taxista.dart';
import 'package:AppTaxisAuto/src/ui/widgets/botones/BtnAceptar.dart';
import 'package:flutter/material.dart';
import '../../../viewmodel/TaxistaViewModel.dart';

class EditarAuto extends StatefulWidget {

  final Taxista data;

  EditarAuto({
    Key key,
    @required this.data,
  }) : super(key: key);

  _EditarAutoState createState() => _EditarAutoState();
}

class _EditarAutoState extends State<EditarAuto> {
  final _formKey = GlobalKey<FormState>();
  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();

  String marca;
  String modelo;
  String placa;
  String documentoID;

  @override
  void initState() {

    marca = widget.data.auto['marca'];
    modelo = widget.data.auto['modelo'];
    placa = widget.data.auto['placa'];
    documentoID = widget.data.documentId;

    super.initState();
  }

  _updateVehiculo() async {

    Map auto = {
      'marca' : marca,
      'modelo' : modelo,
      'placa' : placa,
    };
    
    await _taxistaViewModel.updateVehiculo(auto: auto, documentID: documentoID);
    Navigator.pop(context);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar vehículo'),
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
                    child: Text('MARCA'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: TextEditingController(text: marca != null ? marca+'' : ''),
                      autofocus: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Marca del auto requerida.';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        marca = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('MODELO'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: TextEditingController(text: modelo != null ? modelo+'' : ''),
                      autofocus: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Modelo del auto requirido';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        modelo = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('PLACA'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: TextEditingController(text: placa != null ? placa+'' : ''),
                      autofocus: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Placa del auto requerida';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        placa = value;
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
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _updateVehiculo();
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
