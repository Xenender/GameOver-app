
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:gameover_app/animations/LoadingPage.dart';
import 'package:gameover_app/global/GlobalVariable.dart';

import 'package:gameover_app/repository/trophy/Trophy_model.dart';
import 'package:gameover_app/repository/trophy/Trophy_repository.dart';

import 'package:image_picker/image_picker.dart';

import '../../repository/Storage_service.dart';

class UpdateTrophy extends StatefulWidget {

  String _id = "";

  UpdateTrophy(String id){
    _id = id;
  }

  @override
  _UpdateTrophyState createState() => _UpdateTrophyState(_id);
}

class _UpdateTrophyState extends State<UpdateTrophy> {
  String _id = "";

  String title = "";
  String description = "";

  String selectedImagePath = "";
  bool isDataValid = false;

  String imageRecup = "";
  bool imagechanged = false;

  TextEditingController? _titreController;
  TextEditingController? _descController;

  Storage_service storage_service = Storage_service();
  ImagePicker picker = ImagePicker();
  File? image;

  String precedentFilePath = "";

  String precedentCode = "";


  _UpdateTrophyState(String id){
    _id = id;
  }

  @override
  void initState() {
    super.initState();

    initVariables();


  }

  void initVariables () async {
    final trophy = await parseBdd();

      setState(() {

        _titreController = TextEditingController(text: trophy.titre);
        _descController = TextEditingController(text: trophy.description);
        title = trophy.titre ?? "no title";
        description = trophy.description ?? "no description";

        imageRecup = trophy.img ?? "";
        precedentFilePath = trophy.img ?? "";
        precedentCode = trophy.code ?? "";
        print(title);
        print(imageRecup);
      });



  }

  // Function to choose an image
  Future<void> _selectImage() async {
    chooseImage(ImageSource.gallery).then((value){
      setState(() {
        imagechanged = true;
      });

    });


  }

  // Fonction pour afficher la boîte de dialogue de confirmation
  Future<void> _showDeleteConfirmationDialog(BuildContext context2) async {
    return showDialog(
      context: context2,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Êtes-vous sûr de vouloir supprimer ce trophée ?"),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
            TextButton(
              child: Text("Supprimer"),
              onPressed: () {
                Trophy_repository trophyrep = Trophy_repository();
                trophyrep.deleteIDAndImage(_id).then((value){
                  Navigator.pop(context);
                  Navigator.pop(context2,'data');
                });

              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le trophée"),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete), // Icône de suppression
            onPressed: () {
              // Fonction pour supprimer l'activité ici
              // Vous pouvez afficher une boîte de dialogue de confirmation
              // avant de supprimer l'activité.
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(

                        controller: _titreController,
                        decoration: InputDecoration(labelText: 'Titre'),
                        onChanged: (value) {

                            title = value;

                        },
                      ),
                      TextFormField(

                        controller: _descController,
                        decoration: InputDecoration(labelText: 'Description'),
                        onChanged: (value) {

                            description = value;

                        },
                      ),

                      ListTile(
                        title: Text("Choisir une image"),
                        subtitle: Text(selectedImagePath ?? 'Sélectionner une image'),
                        onTap: () {
                          _selectImage();
                        },
                      ),
                      (image != null) ?
                      Container(height: 200,width: MediaQuery.of(context).size.width,child:Image.file(image!,fit: BoxFit.cover,))
                          :Container(width: 0,height: 0,),

                      !imagechanged?
                        FutureBuilder<String>(

                        future: getUrlDownload(imageRecup),
                        builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child:CircularProgressIndicator()); // En attendant la résolution de la future
                        } else if (snapshot.hasError) {
                        print('Erreur : ${snapshot.error}');
                        return Container(width: 0,height: 0,);
                        } else {
                          return Container(height: 200,width: MediaQuery.of(context).size.width,child: Image.network(snapshot.data??"",fit: BoxFit.cover,));
                        }})
                          : Container(width: 0,height: 0,),



                      ElevatedButton(
                        onPressed: () async {



                          // Valider et convertir les données en TimeStamp
                          if (_validateData()) {

                            print("title");
                            print(title);
                            print("desc");
                            print(description);

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoadingPage()),
                            );

                            //sauvegarde dans la bdd

                            //2 cas : l'image a changé, l'image n'a pas changé

                            //image pas changé, on met l'ancienne adresse d'image en argument pdp de l'activity model

                            Trophy_model trophymodel = Trophy_model(titre: title, description: description,code: precedentCode);

                            if(!imagechanged){
                                trophymodel = Trophy_model(img: precedentFilePath,titre: title, description: description,code: precedentCode);
                            }


                            Trophy_repository trophyrep = Trophy_repository();




                            String idTrophy = await trophyrep.createTrophy(trophymodel);



                            if(imagechanged){
                              //suppression de l'ancienne image
                              trophyrep.deleteIDAndImage(_id).then((value){
                                if(idTrophy != ""){
                                  //envoyer l'image au stockage
                                  storage_service.uploadFile(image!,idTrophy).then((value) {
                                    print("upload fait !");
                                    Navigator.pop(context);
                                    Navigator.pop(context,"data");
                                  });}
                              });


                            }
                            else{
                              //on conserve l'image
                              trophyrep.deleteID(_id).then((value){
                                Navigator.pop(context);
                                Navigator.pop(context,"data");
                              });

                            }










                          }
                          else{
                            print("DONNES NON VALIDES");
                          }
                        },
                        child: Text('Valider',style: TextStyle(color: Colors.white,fontSize: 18)),
                      ),
                    ],
                  ),
                )


            )





    );
  }

  bool _validateData() {
    if (title.isNotEmpty &&
        description.isNotEmpty) {

        setState(() {
          isDataValid = true;
        });
        return true;

    }
    setState(() {
      isDataValid = false;
    });
    return false;
  }

  Future chooseImage(ImageSource source) async{
    XFile? file = await picker.pickImage(source: source,imageQuality: GlobalVariable.trophyQuality);
    if(file != null){
      setState(() {
        image = File(file!.path);
      });
    }

  }

  Future<Trophy_model> parseBdd() async{
    Trophy_repository trophy_rep = Trophy_repository();
    Trophy_model trophy = await trophy_rep.getTrophyFromId(_id);
    return trophy;
  }

  Future<String> getUrlDownload(String imagename) async{
    Storage_service storage = Storage_service();
    String url = await storage.downloadURL(imagename);
    return url;
  }

}
