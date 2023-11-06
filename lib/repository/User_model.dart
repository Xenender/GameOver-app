import 'package:cloud_firestore/cloud_firestore.dart';

class User_model{
  String? id;
  String? username;
  String? pdp;
  int? score;

  User_model({this.id,this.pdp,required this.username,required this.score}){


  }

  toJson(){
    return {
      "username":username,
      "score":score
    };
  }

  factory User_model.fromDocumentSnap(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return User_model(
      id: document.id,
      pdp: data?["pdp"],
      username: data?["username"],
      score: data?["score"],



    );
  }

}