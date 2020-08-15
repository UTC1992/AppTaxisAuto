import 'package:flutter/material.dart';
import '../../../viewmodel/TaxistaViewModel.dart';
import '../../../models/Taxista.dart';

class EditarTelefono extends StatefulWidget {
  final Taxista data;

  EditarTelefono({
    Key key,
    @required this.data,
  }) : super(key: key);

  _EditarTelefonoState createState() => _EditarTelefonoState();
}

class _EditarTelefonoState extends State<EditarTelefono> {
  
  final _formKey = GlobalKey<FormState>();
  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  String telefono;
  String documentID;

  @override
  void initState() {
    super.initState(); 
    telefono = widget.data.telefono;
    documentID = widget.data.documentId;
  }

  _updateTelefonoTaxista () {
    _taxistaViewModel.updateTelefono(telefono: telefono.trim(), documentID: documentID);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar teléfono'),
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
                  child: Text('TELÉFONO DEL USUARIO'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric( horizontal: 20),
                  child: TextFormField(
                    controller: TextEditingController(text: telefono+' '),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Teléfono requerido.';
                      }
                      if(value.length < 10) {
                        return 'Teléfono invalido, debe tener 10 digitos.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      telefono = value;
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
                      _updateTelefonoTaxista();
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
