import 'dart:io';
import 'dart:ui';

import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/animations/LoadingPage.dart';
import 'package:gameover_app/repository/User_repository.dart';
import 'package:gameover_app/repository/trophy/Trophy_model.dart';
import 'package:gameover_app/repository/trophy/Trophy_repository.dart';
import 'package:gameover_app/repository/trophy_user/Trophy_user_model.dart';
import 'package:gameover_app/repository/trophy_user/Trophy_user_repository.dart';
import 'package:gameover_app/repository/user_history/User_history_model.dart';
import 'package:gameover_app/repository/user_history/User_history_repository.dart';
import 'package:gameover_app/updatedLIBS/remote_picture_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/GlobalVariable.dart';
import '../repository/Storage_service.dart';
import '../repository/User_model.dart';

class Leaderboard_profile_menu extends StatefulWidget {

  String? userId;
  Leaderboard_profile_menu(String id){
    this.userId = id;
  }

  @override
  _Leaderboard_profile_menuState createState() => _Leaderboard_profile_menuState(userId??"");

}

class _Leaderboard_profile_menuState extends State<Leaderboard_profile_menu> {

  TextEditingController? _pseudoController;
  bool _isEditable = false;
  String _currentPseudo = ''; // Remplacez par le pseudo initial
  String _currentScore = '0';
  String _userId = "";
  RemotePictureUp? imageRemote = null;

  ImagePicker picker = ImagePicker();
  File? image;

  List<Trophy_model> trophies = [
    // Ajoutez vos trophées ici
  ];

  List<Trophy_user_model> trophiesUsers = [
    // Ajoutez vos trophées ici
  ];

  // Tableau associatif à créer
  Map<String, List<String>> tableauAssociatifTrophy = {};

  //tabHistory
  List<Padding> tabHistorique = [];

  List<GestureDetector> imageTropheesList = [];


  _Leaderboard_profile_menuState(String id){
    this._userId = id;
  }

  @override
  void initState() {
    super.initState();




    _loadProfileImage();
  }

  void _loadProfileImage() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    User_repository user = User_repository();

    List<User_model> listUserModel = await user.allUser();

    User_model userFinal;
    userFinal = User_model(username: "username", score: 0);

    for (var element in listUserModel) {

      if(element.id == _userId){
        userFinal = User_model(id: element.id,username: element.username,pdp: element.pdp, score: element.score);
      }


    }

    //on a l'objet USER !




    setState(() {

      _currentPseudo = userFinal!.username??"";
      _currentScore = userFinal!.score.toString()??"0";
      _pseudoController = TextEditingController(text: _currentPseudo);


    });

    User_repository user_repository = User_repository();
    String? imagePath = await user_repository.getUserImagePath(_userId);

    setState(() {
      imageRemote = RemotePictureUp(imagePath:imagePath!,mapKey: imagePath!,fit: BoxFit.cover,useAvatarView: true,
        avatarViewRadius: 100,);
    });

    //get all trophy
    List<Trophy_model> listeTrophy;
    Trophy_repository trophy_rep = Trophy_repository();
    listeTrophy = await trophy_rep.allTrophy();



    //get all trophy_user

    List<Trophy_user_model> listeTrophyUser;
    Trophy_user_repository trophyUser_rep = Trophy_user_repository();
    listeTrophyUser = await trophyUser_rep.allTrophy_user();

    //creer tab asso

    Map<String, List<String>> tableauAssociatifTrophy2 = {};

    for (Trophy_model Trophy in listeTrophy) {
      // Vous pouvez remplacer cette liste factice par vos propres données
      List<String> idUtilisateurs = [];
      for(Trophy_user_model trophyUser in listeTrophyUser){
        if(trophyUser.trophy == Trophy.code){
          idUtilisateurs.add(trophyUser.user!);
        }
      }

      // Ajouter la clé et la liste d'ID d'utilisateurs dans le tableau associatif
      tableauAssociatifTrophy2[Trophy.code!] = idUtilisateurs;
    }

    print("tab asso");
    print(tableauAssociatifTrophy2);

    setState(() {
      trophies = listeTrophy;
      trophiesUsers = listeTrophyUser;
      tableauAssociatifTrophy = tableauAssociatifTrophy2;


    });

    //remplir tableau historique

    User_history_repository historyRep = User_history_repository();
    List<User_history_model> listHistoryModel = await historyRep.allHistory();

    List<Padding> tabHistorique2 = [];
    for(User_history_model model in listHistoryModel)
      {
        if(model.user == _userId){
          //appartient à son historique
          String text = "${model.titre}: + ${model.xp}Xp";
          tabHistorique2.add(
              Padding(padding: EdgeInsets.only(left: 20),child:

              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                  [
                    Icon(

                      Icons.fiber_manual_record, // Remplacez ceci par l'icône de votre choix
                      color: Theme.of(context).colorScheme.secondary,
                      size: 12,
                    ),
                    SizedBox(width: 8), // Espacement entre l'icône et le texte

                    Text(text,style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.3,
                      ),
                    ),

                    )

                  ]
              )

                ,)

          );
        }
      }
    setState(() {
      tabHistorique = tabHistorique2;

    });



    //charger les trophées dans la liste de container en gris ou couleur



    List<GestureDetector> listeTrophee2 = [];

    for(int index=0;index<trophies.length;index++){
      String trophyCode = trophies[index].code ?? "";
      GestureDetector img = GestureDetector();

      if (tableauAssociatifTrophy[trophyCode]!.contains(_userId)) {
        // L'utilisateur possède le trophy
        print("Possède le trophy");

        img = GestureDetector(onTap: () {
          _showTrophyDetailsDialog(
              context, trophies[index].titre!, trophies[index].description!);
        },
            child:
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                         Theme.of(context).colorScheme.secondary,

                    width: 2.0,
                  ),
                ),
                child: ClipOval(
                  child: image == null
                      ? RemotePictureUp(
                    imagePath: trophies[index].img!,
                    mapKey: trophies[index].img!,
                    fit: BoxFit.cover,
                    useAvatarView: true,
                    avatarViewRadius: 60, // Ajustez la taille du cercle ici
                  )
                      : Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )

        );
      }
            else {
        // Ne possède pas le trophy
        print("Non possédé !");

        img = GestureDetector(onTap: (){
          _showTrophyDetailsDialog(context, trophies[index].titre!, trophies[index].description!);
        },
        child:
        Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black12,
              width: 2.0,
            ),
          ),
          child: ClipOval(
            child: image == null
                ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: RemotePictureUp(
                imagePath: trophies[index].img!,
                mapKey: trophies[index].img!,
                fit: BoxFit.cover,
                useAvatarView: true,
                avatarViewRadius: 60, // Ajustez la taille du cercle ici
              ),
            )
                : Image.file(
              image!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        )

    ,);
      }

      listeTrophee2.add(img);
    }

    setState(() {
      imageTropheesList = listeTrophee2;
    });



    //fin charger les trophées dans la liste de container


  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child:

                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black12,
                              width: 2.0,
                            ),
                          ),
                          child: image ==  null
                                 ?
                                    imageRemote
                                 :
                          ClipOval(child: Image.file(image!,fit: BoxFit.cover,))

                          ,
                        ),






                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                        Text(
                          _currentPseudo,
                          style: TextStyle(fontSize: 22.0),
                        ),


                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Text(
                        "$_currentScore xp",
                        style: TextStyle(fontSize: 22.0),
                      ),


                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 25,bottom: 16,left: 16,right: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star, // Utilisez l'icône de votre choix
                        color: Theme.of(context).colorScheme.primary,
                        size: 30, // Taille de l'icône
                      ),
                      SizedBox(width: 10), // Espace entre l'icône et le texte
                      Text(
                        "Trophées",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                ,
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(

                    height: 80, // Ajustez la hauteur en fonction de votre mise en page
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(

                        children: imageTropheesList,
                      ),
                    )
                  ),
                ),


                Padding(padding: EdgeInsets.only(top: 25,bottom: 16,left: 16,right: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history, // Utilisez l'icône de votre choix
                        color: Theme.of(context).colorScheme.primary,
                        size: 30, // Taille de l'icône
                      ),
                      SizedBox(width: 10), // Espace entre l'icône et le texte
                      Text(
                        "Historique",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),





          Padding(padding: EdgeInsets.only(bottom: 100),child:Column(
                  children: tabHistorique,
                )
          )



              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pseudoController!.dispose();
    super.dispose();
  }

  // Méthode pour afficher la fenêtre de détails du trophée
  void _showTrophyDetailsDialog(BuildContext context, String titre, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titre),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),  
          ],
        );
      },
    );
  }





}
