import 'dart:io';


import 'package:flutter/material.dart';
import 'package:gameover_app/animations/LoadingPage.dart';

import 'package:gameover_app/repository/trophy/Trophy_model.dart';
import 'package:gameover_app/repository/trophy/Trophy_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../repository/Storage_service.dart';

class CreateTrophy extends StatefulWidget {
  @override
  _CreateTrophyState createState() => _CreateTrophyState();
}

class _CreateTrophyState extends State<CreateTrophy> {
  String title = "";
  String description = "";

  String selectedImagePath = "";
  bool isDataValid = false;

  Storage_service storage_service = Storage_service();
  ImagePicker picker = ImagePicker();
  File? image;



  // Function to choose an image
  Future<void> _selectImage() async {
    chooseImage(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un trophée"),

      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Titre'),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),

                ListTile(
                  title: Text("Choisir une image"),
                  subtitle: Text(selectedImagePath ?? 'Sélectionner une image'),
                  onTap: () {
                    _selectImage();
                  },
                ),
                image != null ?
                Image.file(image!)
                :Container(width: 0,height: 0,),



                ElevatedButton(
                  onPressed: () async {



                    // Valider et convertir les données en TimeStamp
                    if (_validateData()) {

                      print("avant push");
                      // Convertir la date et l'heure en TimeStamp
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoadingPage()),
                      );
                      print("apres push");


                      //sauvegarde dans la bdd

                      print("3");
                      Trophy_repository trophyrep = Trophy_repository();
                      
                      Trophy_model trophymodel = Trophy_model(titre: title, description: description);

                      print("4");
                      String idtrophy= await trophyrep.createTrophy(trophymodel);

                      print("id srtockage");
                      print(idtrophy);
                      //envoyer l'image au stockage
                      if(idtrophy != ""){

                      storage_service.uploadFile(image!,idtrophy).then((value) {
                      print("upload fait !");
                      Navigator.pop(context);
                      Navigator.pop(context,"data"); //pour actualisation
                      });}



                    }
                    else{
                      print("DONNES NON VALIDES");
                    }
                  },
                  child: Text('Valider'),
                ),
              ],
            ),
          )


      ),
    );
  }

  bool _validateData() {
    if (title.isNotEmpty &&
        description.isNotEmpty){

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
    XFile? file = await picker.pickImage(source: source,imageQuality: 10);
    if(file != null){
      setState(() {
        image = File(file!.path);
      });
    }

  }
}
