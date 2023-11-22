import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:gameover_app/repository/user_history/User_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class User_history_repository {

  final _db = FirebaseFirestore.instance;

  Future<String> createHistory(User_history_model historique) async { //ajoute l'xp à la bdd et renvoie l'id généré

    String leReturn = "";

    DocumentReference historiqueRef = await _db.collection("user_history").add(historique.toJson()).whenComplete(() {

      print("info envoyées");

    }).catchError(()=>print("erreur d'envoie"));

    if(historiqueRef != null){

      String historiqueId = historiqueRef.id;


      leReturn = historiqueId;


    }

    return leReturn;
  }

  Future<List<User_history_model>> allHistory() async{
    final snapshot = await _db.collection("user_history").get();
    final historyData = snapshot.docs.map((e) => User_history_model.fromDocumentSnap(e)).toList();
    return historyData;
  }

  void deleteHistoryById(String HistoryId) async {
    try {
      await _db.collection("user_history").doc(HistoryId).delete();
      print("supprimé avec succès");
    } catch (error) {
      print("Erreur lors de la suppression du QR code : $error");
    }
  }
}