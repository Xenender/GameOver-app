import 'package:cloud_firestore/cloud_firestore.dart';

class Activity_model{
  String? id;
  String? titre;
  String? description;
  Timestamp? date_debut;
  Timestamp? date_fin;
  String? img;

  Activity_model({this.id,this.img,required this.titre,required this.description,required this.date_debut,required this.date_fin}){


  }

  toJson(){
    return {
      "titre":titre,
      "description":description,
      "date_debut":date_debut,
      "date_fin":date_fin,
    };
  }

  factory Activity_model.fromDocumentSnap(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return Activity_model(
      id: document.id,
      img: data?["img"],
      titre: data?["titre"],
      description: data?["description"],
      date_debut: data?["date_debut"],
      date_fin: data?["date_fin"]



    );
  }

}