import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Trophy_model{
  String? id;
  String? titre;
  String? description;
  String? img;
  String? code;

  Trophy_model({this.id,this.img,required this.titre,required this.description, this.code}){

      /*if(this.code == null){
        //generer code
        int min = 1000;
        int max = 100000;
        Random random = Random();
        int randomNumber = min + random.nextInt(max - min + 1);

        // Conversion du nombre en une chaîne de caractères
        String randomString = randomNumber.toString();
        this.code = "trophy_${randomString}";
      }

       */
  }

  toJson(){
    return {
      "titre":titre,
      "description":description,
      "code":code,
    };
  }

  factory Trophy_model.fromDocumentSnap(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return Trophy_model(
      id: document.id,
      img: data?["img"],
      titre: data?["titre"],
      description: data?["description"],
      code: data?["code"],

    );
  }

}