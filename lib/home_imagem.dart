import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class HomeImagem extends StatefulWidget {
  @override
  State<HomeImagem> createState() => _HomeImagemState();
}

class _HomeImagemState extends State<HomeImagem> {

  var _imagem;
  String _stateUpload = "Upload não iniciado";
  var _urlImagemBaixada = null;

  Future _selecionarImagem(bool daCamera) async {
    var fotocarregada;
    if(daCamera == true){
       fotocarregada = await ImagePicker.platform.getImage(source: ImageSource.camera);
    }
    else{
       fotocarregada = await ImagePicker.platform.getImage(source: ImageSource.gallery);
    }
    setState((){
      _imagem = fotocarregada;
    });
  }


  
  //Método para fazer um Upload no Firebase


  Future _uploadImagem() async {

    //Referenciar arquivo
   FirebaseStorage storage = FirebaseStorage.instance;
   Reference pastaRaiz = storage.ref();//referencia do storage ou melhor a raiz das pastas do storage
   Reference arquivo = pastaRaiz 
   .child("fotos")
   .child("foto1.jpg"); //vai criar uma pasta esta referencia com os nomes de arquivo "foto1"
   
   //Fzer upload da imagem
   UploadTask task = arquivo.putFile(File(_imagem.path));

//Estado do Upload
   task.snapshotEvents.listen((TaskSnapshot taskSnapshot) { 
    
    if(taskSnapshot.state == TaskState.running){
      
      setState(() {
        _stateUpload = "Upload em processo...";
      });

    }
    else if(taskSnapshot.state == TaskState.success){
      setState(() {
        _stateUpload = "Upload com sucesso!";
      });
    }
    else if(taskSnapshot.state == TaskState.error){
      setState(() {
        _stateUpload = "Upload deu erro!";
      });
    }

   });


   //recuperando url da imagem para baixar
   String url = await (await task).ref.getDownloadURL();

   setState(() {
      _urlImagemBaixada = url;
   });
   
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar imagem"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(_stateUpload),
            TextButton(
              onPressed: (){
                _selecionarImagem(true);
              }, 
              child: Text("Camera")
              ,
              style: TextButton.styleFrom(backgroundColor: Colors.lightGreenAccent.shade400)
              ),
              TextButton(
              onPressed: (){
                _selecionarImagem(false);
              }, 
              child: Text("Galeria")
              ,
              style: TextButton.styleFrom(backgroundColor: Colors.lightGreenAccent.shade400)
              ),
              _imagem == null ? Container() : Image.file(File(_imagem.path)),
              _imagem == null 
                ? Container()
                : TextButton(
                  onPressed: (){
                    _uploadImagem();   
                  }, 
                  child: Text("Upload Imagem")
                  ,
                  style: TextButton.styleFrom(backgroundColor: Colors.lightGreenAccent.shade400)
                  ),

              _imagem == null ? Container() : Image.network(_urlImagemBaixada),
          ],
        ),
      ),
    );
  }
}
  