import 'package:AppTaxisAuto/src/models/Ciudad.dart';
import 'package:AppTaxisAuto/src/viewmodel/RegistroViewModel.dart';
import 'package:flutter/material.dart';
import '../../../viewmodel/TaxistaViewModel.dart';
import '../../../models/Taxista.dart';

class EditarCiudad extends StatefulWidget {
  final Taxista data;

  EditarCiudad({
    Key key,
    @required this.data,
  }) : super(key: key);

  _EditarCiudadState createState() => _EditarCiudadState();
}

class _EditarCiudadState extends State<EditarCiudad> {
  
  final _formKey = GlobalKey<FormState>();
  RegistroViewModel _registroViewModel = RegistroViewModel();
  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  String ciudad;
  String documentID;
  var ciudades = new List<Ciudad>();
  final ciudadTextController = TextEditingController();

  @override
  void initState() {
    super.initState(); 
    ciudad = widget.data.ciudad;
    documentID = widget.data.documentId;
    ciudadTextController.text = ciudad;
    _getCiudades();
  }

  _getCiudades() async {
    ciudades = await _registroViewModel.getCiudades();
    print(ciudades[0].nombre);
  }

  _updateTelefonoTaxista () async {
    await _taxistaViewModel.updateCiudad(ciudad: ciudad, documentID: documentID);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ciudad'),
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
                  child: Text('CIUDAD DEL USUARIO'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric( horizontal: 20),
                  child: TextFormField(
                    controller: ciudadTextController,
                    decoration: InputDecoration(
                      hintText: 'Ciudad',
                      suffixIcon: Icon(Icons.expand_more),
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Ciudad requerida.';
                      }
                      return null;
                    },
                    onTap: () {
                      _mostrarCiudades();
                    },
                    readOnly: true,
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

  _asignarCiudad(nombre) {
    ciudadTextController.text = nombre; 
  }

  void _mostrarCiudades() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text("Ciudades disponibles"),
          ),
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.black
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
                    ciudad = ciudades[index].nombre;
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

}
