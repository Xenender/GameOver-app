import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class Storage_service{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(File file,String fileName) async{
    try{
      await storage.ref("/images/$fileName").putFile(file);
    } on firebase_core.FirebaseException catch (e){
      print(e);
    }
  }

  Future<void> uploadBytes(Uint8List bytes,String fileName) async{
    try{
      print("avant storage");
      await storage.ref("/images/$fileName").putData(bytes);
    } on firebase_core.FirebaseException catch (e){
      print("Erreur firebase:");
      print(e);
    }
  }

  Future<void> uploadFileFromAllPath(File file,String path) async{
    try{
      await storage.ref(path).putFile(file);
    } on firebase_core.FirebaseException catch (e){
      print(e);
    }
  }

  Future<void> uploadFileFromAllPathBytes(Uint8List bytes,String path) async{
    try{
      await storage.ref(path).putData(bytes);
    } on firebase_core.FirebaseException catch (e){
      print(e);
    }
  }

  Future<String> downloadURL(String imageName) async{
    String downloadUrl = await storage.ref("$imageName").getDownloadURL();
    return downloadUrl;
  }

  void deleteFile(String name) {
    storage.ref("$name").delete().then((value) => print("delete succeful"));
  }

  /*
  Future<void> uploadData() async{
    final imageBytes = await http.readBytes(Uri.parse(url)); // Assurez-vous d'importer le package http

    final newImageReference = 'nouvelle_reference_vers_l_image_dans_Firestore';

    final newRef = FirebaseStorage.instance.ref().child(newImageReference);
    final uploadTask = newRef.putData(imageBytes);
  }

   */

}