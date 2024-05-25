
import 'package:cached_firestorage/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/animations/ScrollBehavior1.dart';
import 'package:gameover_app/global/GlobalVariable.dart';
import 'package:gameover_app/hub/Profile_menu.dart' if (dart.library.html) 'package:gameover_app/hub/Profile_menu_WEB.dart';
import 'package:gameover_app/hub/Settings_menu.dart';

import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/Activity_repository.dart';
import 'package:gameover_app/repository/Storage_service.dart';


import 'package:gameover_app/repository/User_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../updatedLIBS/remote_picture_up.dart';




class HubEvents extends StatefulWidget {


  @override
  State<HubEvents> createState() => _HubEventsState();
}


class _HubEventsState extends State<HubEvents>{

  double ?screenHeight;
  double ?screenWidth;

  Widget activityLists = CircularProgressIndicator();
  Widget futurePdp = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    _initVariables();
  }

  // Charger les préférences partagées
  _initVariables() async {

    print("init VARIABLES");

    activityLists = await activityList();
    futurePdp = await pdp();

    setState(() {

    });
  }


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
            color: Colors.white,
              padding: EdgeInsetsDirectional.only(top:0,start: 0,end: 0,bottom: 0),
              child: Stack(
                children: [

                      SingleChildScrollView(
                        child: Column(
                          children: [

                            /*

                            Padding(padding: EdgeInsetsDirectional.only(top: 120,),child: ElevatedButton(onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Murder_home(),
                                  ));
                            }, child: Text("murder page")),)
                            ,

                             */
                            Padding(padding: EdgeInsetsDirectional.only(top: 50,bottom: 100),
                            child: activityLists
                            )



                          ],
                        ),
                      )

                  ,

                  //FIRST ROW

                  Container(
                    padding: EdgeInsetsDirectional.only(top:40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                      color: Colors.white.withOpacity(0.9)
                    ),

                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){




                          showModalBottomSheet(
                            context: context,

                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),

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
                          iconSize: 55,
                        ),

                        GestureDetector(child: futurePdp,
                          onTap: (){

                              showModalBottomSheet(


                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                context: context,
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.80, // Définissez la hauteur maximale souhaitée
                                ),
                                isScrollControlled:true,
                                builder: (context) {
                                  GlobalVariable.toolContext = context; // Enregistrez le contexte du menu de paramètres
                                  return ScrollConfiguration(
                                    behavior: ScrollBehavior1(), // Utilisez un ScrollBehavior personnalisé
                                    child: ProfileMenu(), // Affichez votre menu de paramètres ici
                                  );
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
                  ),

                  //APRES FIRST ROW





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

      width: 55,  // 2x le rayon de l'avatar (pour inclure le contour)
      height: 55, // 2x le rayon de l'avatar (pour inclure le contour)
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
        placeholder:"lib/images/no-image-icon-23485.png",
        useAvatarView: true,
        avatarViewRadius: 30,
        fit: BoxFit.cover,
      ),
    );

    return Container(child: futureImage,padding: EdgeInsetsDirectional.only(end: 15),);
  }




  Future<Column> activityList() async{
    Activity_repository activity = Activity_repository();
    Storage_service storage = Storage_service();

    List<Activity_model> listActivityModel = await activity.allActivity();
    List<Padding> lstRow = [];
    listActivityModel.forEach((element) {

      print("ELEMENT IMG");
      print(element.img);
      Container futureContainer = Container(

        width: screenWidth,
        height: 400,
        child: RemotePictureUp(
          imagePath: element.img!,
          mapKey: element.img??'0',
          fit: BoxFit.cover,

        ),

      );


      String deb_mois = element.date_debut!.toDate().month.toString();
      String deb_jour =element.date_debut!.toDate().day.toString();
      String deb_heure = element.date_debut!.toDate().hour.toString();
      String deb_minute = element.date_debut!.toDate().minute.toString();

      String fin_mois = element.date_fin!.toDate().month.toString();
      String fin_jour =element.date_fin!.toDate().day.toString();
      String fin_heure = element.date_fin!.toDate().hour.toString();
      String fin_minute = element.date_fin!.toDate().minute.toString();


      lstRow.add(
          /*
          Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text(element.titre??"Titre"),futureContainer,Text(element.description??"Description")])

           */
          Padding(padding: EdgeInsetsDirectional.only(top: 70),
            child:
            Column(
              children: [
                Padding(padding: EdgeInsetsDirectional.only(start: 10,end: 10),
                  child:
                  Text(
                    element.titre ?? "Titre",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                  ),),

                SizedBox(height: 10), // Espacement entre le titre et l'image
                futureContainer, // Remplacez "element.image" par l'URL de votre image
                SizedBox(height: 10), // Espacement entre l'image et la description
                Padding(padding: EdgeInsetsDirectional.only(start: 10,end: 10),
                  child:
                  Text(

                    element.description ?? "Description",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),),

                SizedBox(height: 10), // Espacement entre la description et les dates

                Text(
                  'Début: ${deb_jour}/${deb_mois}  ${deb_heure}:${deb_minute}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Fin: ${fin_jour}/${fin_mois}  ${fin_heure}:${fin_minute}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            )



      );
    });
    return Column(children: lstRow);
  }


}