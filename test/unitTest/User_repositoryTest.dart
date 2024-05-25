/*
No fonctiona
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:gameover_app/repository/User_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'User_repositoryTest.mocks.dart';

// Création d'une classe abstraite pour représenter une référence de collection
abstract class CollectionReference2<T>{
  // Méthode abstraite pour simuler l'ajout de documents à la collection
  Future<void> add(Map<String, dynamic> data);

  // Méthode abstraite pour simuler la récupération de tous les documents de la collection
  Stream<List<Map<String, dynamic>>> getDocuments();
}

// Implémentation de la classe CollectionReference avec un faux comportement
class MockCollectionReference2<T> implements CollectionReference2<T> {
  List<Map<String, dynamic>> _documents = [];

  @override
  Future<void> add(Map<String, dynamic> data) async {
    _documents.add(data);
  }

  @override
  Stream<List<Map<String, dynamic>>> getDocuments() {
    // Simule le retour d'un flux contenant tous les documents de la collection
    return Stream.value(_documents);
  }
}

@GenerateMocks([FirebaseFirestore])
void main() {

  MockFirebaseFirestore mockFirebaseFirestore = MockFirebaseFirestore();


  User_repository? user_repository;

  group("flutter GameOver app test", (){

    setUpAll(() async {

    user_repository = User_repository(firebaseMock: mockFirebaseFirestore);
  });

  test("Create user", () async {
    User_model user_model = User_model(
        username: "User1", score: 0, pdp: "no pdp");

    /*
    CollectionReference2<Map<String, dynamic>> maCollection = MockCollectionReference2();
    when(mockFirebaseFirestore.collection("users")).thenAnswer((_) => maCollection);

     */


    int nbUser = (await user_repository!.allUser()).length;

  });
});

}