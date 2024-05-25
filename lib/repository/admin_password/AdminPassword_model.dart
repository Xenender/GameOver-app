import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPassword_model{
  String? id;

  String? password;


  AdminPassword_model({this.id,required this.password}){

  }

  toJson(){
    return {
      "password":password,
    };
  }

  factory AdminPassword_model.fromDocumentSnap(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return AdminPassword_model(
        id: document.id,
        password: data?["password"],

    );
  }

}