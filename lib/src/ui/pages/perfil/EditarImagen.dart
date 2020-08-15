import 'dart:async';
import 'dart:io';
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
    Navigator.pop(context);
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imagen = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir imagen'),
      ),
      body: getContainer(),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget getContainer() {
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
                child: Text('FOTOGRAFÍA'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: urlImagen != null
                      ? Image.network(urlImagen)
                      : _imagen != null
                          ? Image.file(_imagen)
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
                  uploadFile();
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
    );
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(documentID + '/configuracion/' + documentID + '.jpeg');
    StorageUploadTask uploadTask = storageReference.putFile(_imagen);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
      _updateUrlImagenTaxista();
      //print(fileURL);
    });
  }

  deleteFile() {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(documentID + '/configuracion/' + documentID + '.jpeg');
    storageReference.delete()
    .then((value) {
      print('imagen eliminada');
    })
    .catchError((onError){
      print(onError);
    });
    
    
  }
}
