import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Qr_model.dart';

class Qr_repository {

  final _db = FirebaseFirestore.instance;

  Future<String> createQr(Qr_model qr) async { //ajoute l'xp à la bdd et renvoie l'id généré

    String leReturn = "";

    DocumentReference qrRef = await _db.collection("qr_code").add(qr.toJson()).whenComplete(() {

      print("info envoyées");

    }).catchError(()=>print("erreur d'envoie"));

    if(qrRef != null){

      String qrId = qrRef.id;


      leReturn = qrId;


    }

    return leReturn;
  }

  Future<List<Qr_model>> allQr() async{
    final snapshot = await _db.collection("qr_code").get();
    final qrData = snapshot.docs.map((e) => Qr_model.fromDocumentSnap(e)).toList();
    return qrData;
  }

  void deleteQrById(String qrId) async {
    try {
      await _db.collection("qr_code").doc(qrId).delete();
      print("QR code supprimé avec succès");
    } catch (error) {
      print("Erreur lors de la suppression du QR code : $error");
    }
  }
}