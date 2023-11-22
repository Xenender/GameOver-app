import 'package:cloud_firestore/cloud_firestore.dart';

class Qr_model{
  String? id;

  String? xp;

  String titre;

  Qr_model({this.id,required this.xp,required this.titre}){

  }

  toJson(){
    return {
      "xp":xp,
      "titre":titre
    };
  }

  factory Qr_model.fromDocumentSnap(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return Qr_model(
        id: document.id,
        xp: data?["xp"],
        titre: data?["titre"]

    );
  }

}