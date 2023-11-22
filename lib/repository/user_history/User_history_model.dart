import 'package:cloud_firestore/cloud_firestore.dart';

class User_history_model{
  String? id;

  String? xp;

  String? titre;

  String? user;

  User_history_model({this.id,required this.xp,required this.titre,required this.user}){

  }

  toJson(){
    return {
      "xp":xp,
      "titre":titre,
      "user":user
    };
  }

  factory User_history_model.fromDocumentSnap(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return User_history_model(
        id: document.id,
        xp: data?["xp"],
        titre: data?["titre"],
        user: data?["user"]

    );
  }

}