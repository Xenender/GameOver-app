
import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/global/GlobalVariable.dart';
import 'package:gameover_app/hub/Profile_menu.dart';
import 'package:gameover_app/hub/Settings_menu.dart';
import 'package:gameover_app/leaderboard/Leaderboard.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/Activity_repository.dart';
import 'package:gameover_app/repository/Storage_service.dart';
import 'dart:io';

import 'package:gameover_app/repository/User_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/User_model.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../updatedLIBS/remote_picture_up.dart';




class HubEvents extends StatefulWidget {


  @override
  State<HubEvents> createState() => _HubEventsState();
}


class _HubEventsState extends State<HubEvents>{

  double ?screenHeight;
  double ?screenWidth;




  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;




    return WillPopScope(
        onWillPop: () async{
          return true;
        },
        child: Scaffold(

          body:
          Container(
              padding: EdgeInsetsDirectional.only(top: 40,start: 20,end: 20,bottom: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){




                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            GlobalVariable.toolContext = context; // Enregistrez le contexte du menu de paramètres
                            return Settings_menu(); // Affichez votre menu de paramètres ici
                          },
                        ).then((value){
                          if(value != null){
                            setState(() {
                              print("reload from settings");
                              //actualiser la page apres un pop avec passage de données
                            });
                          }
                        });

                      }, icon: Icon(Icons.settings),
                        iconSize: 50,
                      ),

                      GestureDetector(child: FutureBuilder<Container>(
                        future: pdp(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // En attendant la résolution de la future
                          } else if (snapshot.hasError) {
                            print('Erreur : ${snapshot.error}');
                            return Container(width: 0,height: 0,);
                          } else {
                            return snapshot.data??Column(children: []);
                          }
                        },
                      ),
                        onTap: (){
                          showModalBottomSheet(
                            context: context,
                              isScrollControlled:true,
                            builder: (context) {
                              GlobalVariable.toolContext = context; // Enregistrez le contexte du menu de paramètres
                              return ProfileMenu(); // Affichez votre menu de paramètres ici
                            },
                          ).then((value){
                            if(value != null){
                              setState(() {
                                //actualiser la page apres un pop avec passage de données
                              });
                            }
                          });
                        },
                      )

                    ],
                  ),
                  //APRES FIRST ROW
                  /*
              ElevatedButton(onPressed: () async{
                SharedPreferences preferences = await SharedPreferences.getInstance();
                await preferences.remove('userId');
                print("ID removed");
              }, child: Text("Delete prefs")),

               */

                ElevatedButton(onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove("userId");
                  prefs.remove("username");
                }, child: Text("del prefs"))
                  ,

                  Expanded(
                      child:
                      SingleChildScrollView(
                        child: Column(
                          children: [

                            FutureBuilder<Column>(

                              future: activityList(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // En attendant la résolution de la future
                                } else if (snapshot.hasError) {
                                  print('Erreur : ${snapshot.error}');
                                  return Container(width: 0,height: 0,);
                                } else {
                                  return snapshot.data??Column(children: []);
                                }
                              },
                            ),


                          ],
                        ),
                      )
                  )

                ],
              )


          ),



        )
    ) ;


  }

  Future<Container> pdp() async{

    Storage_service storage = Storage_service();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    User_repository user_repository = User_repository();
    String? imagePath = await user_repository.getUserImagePath(userId!);


    Container futureImage = Container(
      width: 60,  // 2x le rayon de l'avatar (pour inclure le contour)
      height: 60, // 2x le rayon de l'avatar (pour inclure le contour)
      decoration: BoxDecoration(
        shape: BoxShape.circle, // pour rendre le conteneur rond
        border: Border.all(
          color: Colors.black12, // couleur du contour
          width: 2.0, // largeur du contour (ajustez selon vos préférences)
        ),
      ),
      child: RemotePictureUp(
        imagePath: imagePath!,
        mapKey: imagePath!,
        useAvatarView: true,
        avatarViewRadius: 30,
        fit: BoxFit.cover,
      ),
    );

    return Container(child: futureImage,);
  }




  Future<Column> activityList() async{
    Activity_repository activity = Activity_repository();
    Storage_service storage = Storage_service();

    List<Activity_model> listActivityModel = await activity.allActivity();
    List<Column> lstRow = [];
    listActivityModel.forEach((element) {

      print("ELEMENT IMG");
      print(element.img);
      Container futureContainer = Container(
        width: screenWidth,
        height: 150,
        child: RemotePictureUp(
          imagePath: element.img!,
          mapKey: element.img??'0',
          fit: BoxFit.cover,
        ),

      );




      lstRow.add(
          /*
          Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text(element.titre??"Titre"),futureContainer,Text(element.description??"Description")])

           */
          Column(
            children: [
              Text(
                element.titre ?? "Titre",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10), // Espacement entre le titre et l'image
              futureContainer, // Remplacez "element.image" par l'URL de votre image
              SizedBox(height: 10), // Espacement entre l'image et la description
              Text(
                element.description ?? "Description",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10), // Espacement entre la description et les dates

                  Text(
                    'Date de début: ${DateTime.fromMillisecondsSinceEpoch(element.date_debut!.millisecondsSinceEpoch)}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Date de fin: ${DateTime.fromMillisecondsSinceEpoch(element.date_fin!.millisecondsSinceEpoch)}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),


      );
    });
    return Column(children: lstRow);
  }


}