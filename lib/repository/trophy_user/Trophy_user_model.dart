import 'package:cloud_firestore/cloud_firestore.dart';

class Trophy_user_model{

  String? id;

  String? trophy;

  String? user;

  Trophy_user_model({this.id,required this.user,required this.trophy}){

  }

  toJson(){
    return {
      "user":user,
      "trophy":trophy
    };
  }

  factory Trophy_user_model.fromDocumentSnap(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return Trophy_user_model(
        id: document.id,
        user: data?["user"],
        trophy: data?["trophy"]

    );
  }

}