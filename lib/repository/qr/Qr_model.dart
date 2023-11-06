import 'package:cloud_firestore/cloud_firestore.dart';

class Qr_model{
  String? id;

  int? xp;

  Qr_model({this.id,required this.xp}){

  }

  toJson(){
    return {
      "xp":xp,
    };
  }

  factory Qr_model.fromDocumentSnap(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return Qr_model(
        id: document.id,
        xp: data?["xp"],

    );
  }

}