import 'dart:async';
import 'dart:io';
import 'package:AppTaxisAuto/src/ui/widgets/botones/BtnAceptar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../viewmodel/TaxistaViewModel.dart';
import '../../../models/Taxista.dart';

class EditarImagen extends StatefulWidget {
  final Taxista data;

  EditarImagen({
    Key key,
    @required this.data,
  }) : super(key: key);

  _EditarImagenState createState() => _EditarImagenState();
}

class _EditarImagenState extends State<EditarImagen> {
  File _imagen;
  String _uploadedFileURL;
  final picker = ImagePicker();

  TaxistaViewModel _taxistaViewModel = TaxistaViewModel();
  String urlImagen;
  String documentID;

  @override
  void initState() {
    super.initState();
    urlImagen = widget.data.urlImagen;
    print(urlImagen);
    documentID = widget.data.documentId;
  }

  _updateUrlImagenTaxista() {
    _taxistaViewModel.updateUrlImagen(
        urlImagen: _uploadedFileURL, documentID: documentID);
    //Navigator.pop(context);
  }

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        _imagen = File(pickedFile.path);
      });
    } catch (e) {
      print(e.toString());
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir imagen'),
      ),
      body: getContainer(),
      
    );
  }

  Widget getContainer() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Fotografía',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: screenSize.width * 0.7,
                  height: screenSize.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: urlImagen != ''
                      ? Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Image.network(urlImagen)
                        )
                      : _imagen != null
                          ? Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Image.file(_imagen),
                            )
                          : Center(
                              child: Text(
                              'Seleccione una imagen',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (urlImagen != '' || _imagen != null) {
                    deleteImagen();
                  } else {
                    getImage();
                  }
                },
                child: Container(
                  width: screenSize.width * 0.16,
                  height: screenSize.width * 0.16,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: urlImagen != '' || _imagen != null
                      ? Colors.red[400]
                      : Colors.blue[300], 
                      width: 3),
                    borderRadius: BorderRadius.circular(360.0),
                  ),
                  child: urlImagen != '' || _imagen != null
                          ? Icon(Icons.delete_forever, 
                            size: screenSize.width * 0.1,
                            color: Colors.red[400],
                          )
                          : Icon(Icons.camera_alt, 
                            size: screenSize.width * 0.1,
                            color: Colors.blue[500],
                          ),
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
                      uploadFile();
                    },
                    titulo: 'Actualizar',
                    alto: 45,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future uploadFile() async {
    if(_imagen != null) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child(documentID + '/configuracion/' + documentID + '.jpeg');
      StorageUploadTask uploadTask = storageReference.putFile(_imagen);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          urlImagen = fileURL;
          _uploadedFileURL = fileURL;
        });
        _updateUrlImagenTaxista();
        //print(fileURL);
      });
    }
  }

  deleteImagen() {
    if(urlImagen != '') {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child(documentID + '/configuracion/' + documentID + '.jpeg');
      storageReference.delete()
      .then((value) {
        print('imagen eliminada');
        setState(() {
          urlImagen = '';
          _imagen = null;
          _uploadedFileURL = '';
        });
        _updateUrlImagenTaxista();
      })
      .catchError((onError){
        print(onError);
      });
    } else {
      setState(() {
        urlImagen = '';
        _imagen = null;
        _uploadedFileURL = '';
      });
    }
  } 
}
