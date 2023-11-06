import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/Storage_service.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity_repository {

  final _db = FirebaseFirestore.instance;

  Future<String> createActivity(Activity_model activity) async {

    String leReturn = "";

    DocumentReference activityRef = await _db.collection("activity").add(activity.toJson()).whenComplete(() async {

      print("info envoyées");

    }).catchError(()=>print("erreur d'envoie"));

    if(activityRef != null){

      String activityId = activityRef.id;

      //ajouter le chemin vers pdp à l'objet USER avec le bon nomage

      if(activity.img != null){
        await _db.collection("activity")
            .doc(activityId) // <-- Doc ID where data should be updated.
            .update({"img":"${activity.img}"})
            .then((value) => null);
      }
      else{
        await _db.collection("activity")
            .doc(activityId) // <-- Doc ID where data should be updated.
            .update({"img":"images/$activityId"})
            .then((value) => null);
      }




      //Ajouter la pdp avec le non nomage au STOCKAGE là onj on a effectué le create user grace au RETURN

      leReturn = activityId;


    }

    return leReturn;
  }

  Future<List<Activity_model>> allActivity() async{
    final snapshot = await _db.collection("activity").get();
    final activityData = snapshot.docs.map((e) => Activity_model.fromDocumentSnap(e)).toList();
    return activityData;
  }

  Future<Activity_model> getActivityFromId(String id) async{
    Activity_model model;
    final DocumentSnapshot activitySnapshot = await FirebaseFirestore.instance.collection("activity").doc(id).get();
    if(activitySnapshot.exists){
      final activityData = activitySnapshot.data() as Map<String, dynamic>?;
      String ida = activitySnapshot.id;
      String titre = activityData!["titre"] as String;
      String description = activityData!["description"] as String;
      String img = activityData!["img"] as String;
      Timestamp date_debut = activityData!["date_debut"] as Timestamp;
      Timestamp date_fin = activityData!["date_fin"] as Timestamp;

      model = Activity_model(id: ida, img: img, titre: titre, description: description, date_debut: date_debut, date_fin: date_fin);

    }
    else{
      model = Activity_model(titre: "no titre", description: "no description", date_debut: Timestamp.now(), date_fin: Timestamp.now());
    }

    return model;
  }

  Future<void> deleteIDAndImage(String id) async {
    try {
      final DocumentSnapshot activitySnapshot = await FirebaseFirestore.instance.collection("activity").doc(id).get();
      final activityData = activitySnapshot.data() as Map<String, dynamic>?;
      String imagePath = activityData!["img"];
      await _db.collection("activity").doc(id).delete();
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
      final DocumentSnapshot activitySnapshot = await FirebaseFirestore.instance.collection("activity").doc(id).get();
      final activityData = activitySnapshot.data() as Map<String, dynamic>?;
      String imagePath = activityData!["img"];
      await _db.collection("activity").doc(id).delete();
      print("Document supprimé avec succès.");

    } catch (e) {
      print("Erreur lors de la suppression du document : $e");
    }
  }
}