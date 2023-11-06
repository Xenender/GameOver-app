import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/animations/LoadingPage.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/Activity_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../repository/Storage_service.dart';

class CreateActivity extends StatefulWidget {
  @override
  _CreateActivityState createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  String title = "";
  String description = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  String selectedImagePath = "";
  bool isDataValid = false;

  Storage_service storage_service = Storage_service();
  ImagePicker picker = ImagePicker();
  File? image;

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
    chooseImage(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une activité"),

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
                      print("1");

                      Timestamp timeStampDebut = Timestamp.fromDate(dateTimeDebut);
                      Timestamp timeStampFin = Timestamp.fromDate(dateTimeFin);
                      
                      
                      //sauvegarde dans la bdd

                      print("3");
                      Activity_repository activityrep = Activity_repository();
                      
                      Activity_model activityModel = Activity_model(titre: title, description: description, date_debut: timeStampDebut, date_fin: timeStampFin);

                      print("4");
                      String idActi = await activityrep.createActivity(activityModel);

                      print("id srtockage");
                      print(idActi);
                      //envoyer l'image au stockage
                      if(idActi != ""){

                      storage_service.uploadFile(image!,idActi).then((value) {
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
    XFile? file = await picker.pickImage(source: source,imageQuality: 10);
    if(file != null){
      setState(() {
        image = File(file!.path);
      });
    }

  }
}
