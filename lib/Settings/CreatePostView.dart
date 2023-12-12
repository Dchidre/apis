


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../FbObjects/fbPost.dart';
import '../FbObjects/fbUser.dart';
import '../Singletone/DataHolder.dart';
import '../components/customBtn.dart';
import '../components/textField.dart';

class CreatePostView extends StatefulWidget {
  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}


class _CreatePostViewState extends State<CreatePostView> {

  //var
  final tecTitle = TextEditingController();
  final tecBody = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  ImagePicker _picker = ImagePicker();
  File _imagePreview = File("");
  late fbUser user;

  //methods
  void openGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }
  void openCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePreview = File(image.path);
      });
    }
  }
  void getUser() async {
    user = await DataHolder().fbAdmin.getCurrentUser();
  }
  void uploadPost() async {
    //getCurrentUser--- INICIO SUBIR IMAGEN ----------
    final storageRef = FirebaseStorage.instance.ref();
    String rutaEnNube = "posts/" +
        FirebaseAuth.instance.currentUser!.uid +
        "/imgs/"+
        DateTime.now().toString()+
        ".jpg";
    final rutaAFicheroEnNube = storageRef.child(rutaEnNube);
    final metadata = SettableMetadata(contentType: "image/jpg");

    try {
      await rutaAFicheroEnNube.putFile(_imagePreview, metadata);
    }
    on FirebaseException catch (e) {

    }

    print("SE HA SUBIDO LA IMAGEEEEEENNNNNN");

    String imgUrl = await rutaAFicheroEnNube.getDownloadURL();

    print("Se ha subido la imagen ----------->>>>>>>>" + imgUrl);

    //---------- FIN DE SUBIR IMAGEN ----------

    //---------- INICIO DE SUBIR POST ----------

    fbPost newPost = fbPost(
      title: tecTitle.text,
      body: tecBody.text,
      sUrlImg: imgUrl,
      sUserName: user.name,
      idUser: FirebaseAuth.instance.currentUser!.uid,
      idPost: "",
    );
    DataHolder().createPostInFB(newPost);

    //---------- FIN DE SUBIR POST ----------

    Navigator.of(context).pop();
  }

  //initialize
  @override
  void initState() {
    getUser();
    super.initState();
  }

  //paint
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create post'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
      ),
      body:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textField(sLabel: 'Title', myController: tecTitle, icIzq: Icons.title_outlined),
              textField(sLabel: 'Body', myController: tecBody, icIzq: Icons.textsms_outlined),
              SizedBox(height: 50),
              _imagePreview.path == ''?
              SizedBox() : Image.file(_imagePreview, width: 200, height: 200, fit: BoxFit.cover),
              SizedBox(height: 50),
              Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customBtn(fAction: openGallery, sText: "Gallery"),
                  SizedBox(width: 50),
                  customBtn(fAction: openCamera, sText: "Cámara"),
                ],
              ),
              SizedBox(height: 30,),
              customBtn(fAction:() {uploadPost();}, sText: 'Post!'),
            ],
          )
    );
  }
}