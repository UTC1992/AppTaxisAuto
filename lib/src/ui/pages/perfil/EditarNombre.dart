import 'package:flutter/material.dart';
import '../../../viewmodel/TaxistaViewModel.dart';
import '../../../models/Taxista.dart';

class EditarNombre extends StatefulWidget {
  final Taxista data;

  EditarNombre({
    Key key,
    @required this.data,
  }) : super(key: key);

  _EditarNombreState createState() => _EditarNombreState();
}

class _EditarNombreState extends State<EditarNombre> {
  
  final _formKey = GlobalKey<FormState>();
  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  String nombre;
  String documentID;

  @override
  void initState() {
    super.initState(); 
    nombre = widget.data.nombre;
    documentID = widget.data.documentId;
  }

  _updateNombreTaxista () {
    _taxistaViewModel.updateNombre(nombre: nombre.trim(), documentID: documentID);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar nombre'),
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
                    controller: TextEditingController(text: nombre+' '),
                    autofocus: true,
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Debe ingresar su nombre y apellido';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      nombre = value;
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
                      _updateNombreTaxista();
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