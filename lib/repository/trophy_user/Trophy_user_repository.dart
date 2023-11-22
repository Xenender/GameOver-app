import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gameover_app/repository/trophy_user/Trophy_user_model.dart';


class Trophy_user_repository {

  final _db = FirebaseFirestore.instance;

  Future<String> createTrophy_user(Trophy_user_model Tu) async { //ajoute l'xp à la bdd et renvoie l'id généré

    String leReturn = "";

    DocumentReference TuRef = await _db.collection("trophy_user").add(Tu.toJson()).whenComplete(() {

      print("info envoyées");

    }).catchError(()=>print("erreur d'envoi"));

    if(TuRef != null){

      String TuId = TuRef.id;


      leReturn = TuId;


    }

    return leReturn;
  }

  Future<List<Trophy_user_model>> allTrophy_user() async{
    final snapshot = await _db.collection("trophy_user").get();
    final TuData = snapshot.docs.map((e) => Trophy_user_model.fromDocumentSnap(e)).toList();
    return TuData;
  }

  void deleteQrById(String TuId) async {
    try {
      await _db.collection("qr_code").doc(TuId).delete();
      print("QR code supprimé avec succès");
    } catch (error) {
      print("Erreur lors de la suppression du QR code : $error");
    }
  }
}