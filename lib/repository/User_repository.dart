import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User_repository {
  FirebaseFirestore? firebaseMock = null;


  FirebaseFirestore? _db;

  User_repository({this.firebaseMock=null}){
    firebaseMock != null ? _db = firebaseMock! : _db = FirebaseFirestore.instance;
  }

  Future<String> createUser(User_model user) async {

    String leReturn = "";

    DocumentReference userRef = await _db!.collection("users").add(user.toJson()).whenComplete(() async {

      print("info envoyées");

    }).catchError(()=>print("erreur d'envoie"));

    if(userRef != null){
      //actu shared prefs
      print("ajout shared prefs");
      String userId = userRef.id;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userId);
      prefs.setString('username', user.username!);


      //ajouter le chemin vers pdp à l'objet USER avec le bon nomage


      await _db!.collection("users")
          .doc(userId) // <-- Doc ID where data should be updated.
          .update({"pdp":"images/$userId"})
          .then((value) => null);



      //Ajouter la pdp avec le non nomage au STOCKAGE là onj on a effectué le create user grace au RETURN

      leReturn = userId;


    }

    return leReturn;
  }

  Future<List<User_model>> allUser() async{
    final snapshot = await _db!.collection("users").get();
    final userData = snapshot.docs.map((e) => User_model.fromDocumentSnap(e)).toList();
    return userData;
  }

  Future<int?> getUserScore(String userId) async {
    try {
      final DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(userId).get();

      if (userSnapshot.exists) {

        final userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey("score")) {

          final int score = userData["score"] as int;
          return score;


        } else {
          // L'utilisateur n'a pas de score défini.
          return null;
        }
      }


      else {
        // L'utilisateur avec cet ID n'existe pas.
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération du score de l'utilisateur : $e");
      return null;
    }
  }

  Future<void> updateUserScore(String userId, int newScore) async {
    try {
      final userReference =
      FirebaseFirestore.instance.collection("users").doc(userId);

      await userReference.update({
        "score": newScore,
      });

      print("Score de l'utilisateur avec l'ID $userId mis à jour avec succès.");
    } catch (e) {
      print("Erreur lors de la mise à jour du score de l'utilisateur : $e");
    }
  }

  Future<void> addToUserScore(String userId, int scoreToAdd) async {
    // Obtenir le score actuel de l'utilisateur.
    int? currentScore = await getUserScore(userId);

    if (currentScore != null) {
      // Ajouter le score à la valeur actuelle.
      int newScore = currentScore + scoreToAdd;

      // Mettre à jour le score de l'utilisateur avec la nouvelle valeur.
      await updateUserScore(userId, newScore);

      print("Score de l'utilisateur avec l'ID $userId mis à jour avec succès. Nouveau score : $newScore");
    } else {
      print("Impossible de mettre à jour le score de l'utilisateur avec l'ID $userId, car l'utilisateur n'existe pas ou n'a pas de score défini.");
    }
  }

  Future<void> updateUserPseudo(String userId, String newPseudo) async {
    try {
      final userReference =
      FirebaseFirestore.instance.collection("users").doc(userId);

      await userReference.update({
        "username": newPseudo,
      });

      print("Score de l'utilisateur avec l'ID $userId mis à jour avec succès.");
    } catch (e) {
      print("Erreur lors de la mise à jour du score de l'utilisateur : $e");
    }
  }


  Future<String?> getUserImagePath(String userId) async {
    try {
      final DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(userId).get();

      if (userSnapshot.exists) {

        final userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey("pdp")) {

          final String imagePath = userData["pdp"] as String;
          return imagePath;


        } else {

          return null;
        }
      }


      else {
        // L'utilisateur avec cet ID n'existe pas.
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération du score de l'utilisateur : $e");
      return null;
    }
  }


  Future<bool> deleteUserByName(String username) async {

    String id = "";
    //find user id
    List<User_model> userList = await allUser();

    for(User_model user in userList){
        if(user.username == username) id = user.id!;
    }
    try {

      await FirebaseFirestore.instance.collection("users").doc(id).delete();
      return true;

    } catch (e) {
      print("Erreur lors de la suppression user : $e");
      return false;
    }
  }





}