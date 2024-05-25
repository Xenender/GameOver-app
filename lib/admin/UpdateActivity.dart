
import 'dart:io';

import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/animations/LoadingPage.dart';
import 'package:gameover_app/global/GlobalVariable.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/Activity_repository.dart';
import 'package:gameover_app/updatedLIBS/remote_picture_up.dart';
import 'package:image_picker/image_picker.dart';

import '../repository/Storage_service.dart';

class UpdateActivity extends StatefulWidget {

  String _id = "";

  UpdateActivity(String id){
    _id = id;
  }

  @override
  _UpdateActivityState createState() => _UpdateActivityState(_id);
}

class _UpdateActivityState extends State<UpdateActivity> {
  String _id = "";

  bool firstStart = true;


  String title = "";
  String description = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  String selectedImagePath = "";
  bool isDataValid = false;

  String imageRecup = "";
  bool imagechanged = false;

  Storage_service storage_service = Storage_service();
  ImagePicker picker = ImagePicker();
  File? image;

  String precedentFilePath = "";

  Future<Activity_model>? futureData;

  _UpdateActivityState(String id){
    _id = id;
  }

  @override
  void initState() {
    super.initState();



  }

  Future<void> _selectStartDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        endTime = pickedTime;
      });
    }
  }

  // Function to choose an image
  Future<void> _selectImage() async {
    chooseImage(ImageSource.gallery).then((value){
      setState(() {
        imagechanged = true;
        //delete ancienne image du cache
        CachedFirestorage.instance.removeCacheEntry(mapKey: imageRecup);
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
          content: Text("Êtes-vous sûr de vouloir supprimer cette activité ?"),
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
                Activity_repository activityrep = Activity_repository();
                activityrep.deleteIDAndImage(_id).then((value){
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
        title: const Text("Créer une activité"),

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
      body: FutureBuilder<Activity_model>(

        future: parseBdd(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:CircularProgressIndicator()); // En attendant la résolution de la future
          } else if (snapshot.hasError) {
            print('Erreur : ${snapshot.error}');
            return Container(width: 0,height: 0,);
          } else {
            Activity_model acti_model = snapshot.data!;

            print("future build");
            print(acti_model.titre);
            print(acti_model.date_debut);

            //Init de toutes les variables en fonction de ce qu'on récup dans la bdd:
            if(firstStart){
              firstStart = false;

              title = acti_model.titre??"no titre";
              description = acti_model.description??"no description";
              Timestamp timestamp_debut = acti_model.date_debut??Timestamp.now();
              Timestamp timestamp_fin = acti_model.date_fin??Timestamp.now();

              DateTime dataTime1_debut = DateTime.fromMillisecondsSinceEpoch(timestamp_debut.millisecondsSinceEpoch);
              DateTime dataTime1_fin = DateTime.fromMillisecondsSinceEpoch(timestamp_fin.millisecondsSinceEpoch);

              startTime = TimeOfDay.fromDateTime(dataTime1_debut);
              endTime = TimeOfDay.fromDateTime(dataTime1_fin);

              startDate = dataTime1_debut;
              endDate = dataTime1_fin;

              imageRecup = acti_model.img??"";

              print("image recup");
              print(imageRecup);

              precedentFilePath = acti_model.img??"";
              //FIN RECUP DONNES

            }




            return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: title,
                        decoration: InputDecoration(labelText: 'Titre'),
                        onChanged: (value) {

                            title = value;

                        },
                      ),
                      TextFormField(
                        initialValue: description,
                        decoration: InputDecoration(labelText: 'Description'),
                        onChanged: (value) {

                            description = value;

                        },
                      ),
                      ListTile(
                        title: Text("Date de début"),
                        subtitle: Text(startDate != null ? "${startDate.toLocal()}".split(' ')[0] : 'Sélectionner la date'),
                        onTap: () {
                          _selectStartDate(context);
                        },
                      ),
                      ListTile(
                        title: Text("Date de fin"),
                        subtitle: Text(endDate != null ? "${endDate.toLocal()}".split(' ')[0] : 'Sélectionner la date'),
                        onTap: () {
                          _selectEndDate(context);
                        },
                      ),
                      ListTile(
                        title: Text("Heure de début"),
                        subtitle: Text(startTime != null ? "${startTime.format(context)}" : 'Sélectionner l\'heure'),
                        onTap: () {
                          _selectStartTime(context);
                        },
                      ),
                      ListTile(
                        title: Text("Heure de fin"),
                        subtitle: Text(endTime != null ? "${endTime.format(context)}" : 'Sélectionner l\'heure'),
                        onTap: () {
                          _selectEndTime(context);
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

                            Container(height: 200,width: MediaQuery.of(context).size.width,child: RemotePictureUp(imagePath: imageRecup, mapKey: imageRecup,fit: BoxFit.cover,) )


                          : Container(width: 0,height: 0,),



                      ElevatedButton(
                        onPressed: () async {



                          // Valider et convertir les données en TimeStamp
                          if (_validateData()) {

                            print("title");
                            print(title);
                            print("desc");
                            print(description);
                            // Convertir la date et l'heure en TimeStamp
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoadingPage()),
                            );


                            final dateTimeDebut = DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                              startTime.hour,
                              startTime.minute,
                            );

                            final dateTimeFin = DateTime(
                              endDate.year,
                              endDate.month,
                              endDate.day,
                              endTime.hour,
                              endTime.minute,
                            );

                            Timestamp timeStampDebut = Timestamp.fromDate(dateTimeDebut);
                            Timestamp timeStampFin = Timestamp.fromDate(dateTimeFin);


                            //sauvegarde dans la bdd

                            //2 cas : l'image a changé, l'image n'a pas changé

                            //image pas changé, on met l'ancienne adresse d'image en argument pdp de l'activity model

                            Activity_model activityModel = Activity_model(titre: title, description: description, date_debut: timeStampDebut, date_fin: timeStampFin);

                            if(!imagechanged){
                                activityModel = Activity_model(img: precedentFilePath,titre: title, description: description, date_debut: timeStampDebut, date_fin: timeStampFin);
                            }


                            Activity_repository activityrep = Activity_repository();




                            String idActi = await activityrep.createActivity(activityModel);



                            if(imagechanged){
                              //suppression de l'ancienne image
                              activityrep.deleteIDAndImage(_id);

                              if(idActi != ""){
                                //envoyer l'image au stockage
                                storage_service.uploadFile(image!,idActi).then((value) {
                                  print("upload fait !");
                                  Navigator.pop(context);
                                  Navigator.pop(context,"data");
                                });}
                            }
                            else{
                              //on conserve l'image
                              activityrep.deleteID(_id).then((value){
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


            );
          }
        },
      ),




    );
  }

  bool _validateData() {
    if (title.isNotEmpty &&
        description.isNotEmpty &&
        startDate != null &&
        endDate != null &&
        startTime != null &&
        endTime != null) {
      final startDateTime = DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute);
      final endDateTime = DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);

      if (startDateTime.isBefore(endDateTime) || startDateTime.isAtSameMomentAs(endDateTime)) {
        setState(() {
          isDataValid = true;
        });
        return true;
      }
    }
    setState(() {
      isDataValid = false;
    });
    return false;
  }

  Future chooseImage(ImageSource source) async{
    XFile? file = await picker.pickImage(source: source,imageQuality: GlobalVariable.eventQuality);
    if(file != null){
      setState(() {
        image = File(file!.path);
      });
    }

  }

  Future<Activity_model> parseBdd() async{
    Activity_repository acti_rep = Activity_repository();
    Activity_model activity = await acti_rep.getActivityFromId(_id);
    return activity;
  }

  Future<String> getUrlDownload(String imagename) async{
    Storage_service storage = Storage_service();
    String url = await storage.downloadURL(imagename);
    return url;
  }

}
