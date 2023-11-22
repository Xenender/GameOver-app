import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gameover_app/repository/Storage_service.dart';
import 'package:gameover_app/repository/trophy/Trophy_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trophy_repository {

  final _db = FirebaseFirestore.instance;

  Future<String> createTrophy(Trophy_model trophy) async {

    String leReturn = "";

    DocumentReference trophyRef = await _db.collection("trophy").add(trophy.toJson()).whenComplete(() async {

      print("info envoyées");

    }).catchError(()=>print("erreur d'envoie"));

    if(trophyRef != null){

      String trophyId = trophyRef.id;

      //ajouter le chemin vers pdp à l'objet USER avec le bon nomage

      if(trophy.img != null){
        await _db.collection("trophy")
            .doc(trophyId) // <-- Doc ID where data should be updated.
            .update({"img":"${trophy.img}"})
            .then((value) => null);
      }
      else{

        //update image
        await _db.collection("trophy")
            .doc(trophyId) // <-- Doc ID where data should be updated.
            .update({"img":"images/$trophyId"})
            .then((value) => null);


      }
      if(trophy.code == null){
        //update code
        await _db.collection("trophy")
            .doc(trophyId) // <-- Doc ID where data should be updated.
            .update({"code":"code_$trophyId"})
            .then((value) => null);
      }




      //Ajouter la pdp avec le non nomage au STOCKAGE là onj on a effectué le create user grace au RETURN

      leReturn = trophyId;


    }

    return leReturn;
  }

  Future<List<Trophy_model>> allTrophy() async{
    final snapshot = await _db.collection("trophy").get();
    final trophyData = snapshot.docs.map((e) => Trophy_model.fromDocumentSnap(e)).toList();
    return trophyData;
  }

  Future<Trophy_model> getTrophyFromId(String id) async{
    Trophy_model model;
    final DocumentSnapshot trophySnapshot = await FirebaseFirestore.instance.collection("trophy").doc(id).get();
    if(trophySnapshot.exists){
      final trophyData = trophySnapshot.data() as Map<String, dynamic>?;
      String ida = trophySnapshot.id;
      String titre = trophyData!["titre"] as String;
      String description = trophyData!["description"] as String;
      String img = trophyData!["img"] as String;
      String code = trophyData!["code"] as String;

      model = Trophy_model(id: ida, img: img, titre: titre, description: description, code:code);

    }
    else{
      model = Trophy_model(titre: "no titre", description: "no description", code: "no code");
    }

    return model;
  }

  Future<void> deleteIDAndImage(String id) async {
    try {
      final DocumentSnapshot trophySnapshot = await FirebaseFirestore.instance.collection("trophy").doc(id).get();
      final trophyData = trophySnapshot.data() as Map<String, dynamic>?;
      String imagePath = trophyData!["img"];
      await _db.collection("trophy").doc(id).delete();
      print("Document supprimé avec succès.");

      //on va supprimer l'image également

      Storage_service storage_service = Storage_service();
      storage_service.deleteFile(imagePath);
    } catch (e) {
      print("Erreur lors de la suppression du document : $e");
    }
  }

  Future<void> deleteID(String id) async {
    try {
      final DocumentSnapshot trophySnapshot = await FirebaseFirestore.instance.collection("trophy").doc(id).get();
      final trophyData = trophySnapshot.data() as Map<String, dynamic>?;
      String imagePath = trophyData!["img"];
      await _db.collection("trophy").doc(id).delete();
      print("Document supprimé avec succès.");

    } catch (e) {
      print("Erreur lors de la suppression du document : $e");
    }
  }
}