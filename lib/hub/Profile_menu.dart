import 'dart:io';

import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/animations/LoadingPage.dart';
import 'package:gameover_app/repository/User_repository.dart';
import 'package:gameover_app/updatedLIBS/remote_picture_up.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/GlobalVariable.dart';
import '../repository/Storage_service.dart';

class ProfileMenu extends StatefulWidget {
  @override
  _ProfileMenuState createState() => _ProfileMenuState();

}

class _ProfileMenuState extends State<ProfileMenu> {
  TextEditingController? _pseudoController;
  bool _isEditable = false;
  String _currentPseudo = ''; // Remplacez par le pseudo initial
  String _userId = "";
  RemotePictureUp? imageRemote = null;

  ImagePicker picker = ImagePicker();
  File? image;

  List<String> trophies = [
    'Trophée 1',
    'Trophée 2',
    'Trophée 3',
    'Trophée 4',
    'Trophée 5',
    'Trophée 6',
    // Ajoutez vos trophées ici
  ];



  @override
  void initState() {
    super.initState();




    _loadProfileImage();
  }

  void _loadProfileImage() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();




    setState(() {

      _currentPseudo = prefs.getString("username")??"";
      _pseudoController = TextEditingController(text: _currentPseudo);
      _userId = prefs.getString("userId")??"";

    });

    User_repository user_repository = User_repository();
    String? imagePath = await user_repository.getUserImagePath(_userId);

    setState(() {
      imageRemote = RemotePictureUp(imagePath:imagePath!,mapKey: imagePath!,fit: BoxFit.cover,useAvatarView: true,
        avatarViewRadius: 100,);
    });



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
                  GestureDetector(
                    onTap: () {
                      print("Cliquez pour modifier l'image");

                      chooseImage(ImageSource.gallery);

                      // Insérez le code pour changer l'image ici
                    },
                    child: Stack(
                      children: [
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
                        Positioned(
                          bottom: 0, // Positionnez le logo au bas de l'image
                          right: 0, // Positionnez le logo à droite de l'image
                          child: Container(
                            width: 40, // Ajustez la taille du conteneur du logo selon vos préférences
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black12,
                                width: 2.0,
                              ),
                              color: Colors.white, // Fond blanc du logo stylo
                            ),
                            child: Icon(
                              Icons.edit, // Utilisez l'icône du stylo (vous pouvez en choisir un autre si vous préférez)
                              color: Colors.blue, // Couleur de l'icône du stylo
                            ),
                          ),
                        ),
                      ],
                    ),
                  )




                ),
                SizedBox(height: 10.0),
                _isEditable
                    ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _pseudoController,

                          decoration: InputDecoration(
                            labelText: 'Pseudo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {

                          //check pseudo valide

                          if(_pseudoController!.text != "" && _pseudoController!.text != _currentPseudo){


                            setState(() {
                              _isEditable = false;
                              _currentPseudo = _pseudoController!.text;

                            });

                          }
                          else{
                            setState(() {
                              _isEditable = false;

                            });
                          }

                          //enregister pseudo




                        },
                      ),
                    ],
                  ),
                )
                    : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _currentPseudo,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit,color: Colors.blue,),
                        onPressed: () {
                          setState(() {
                            _isEditable = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                ElevatedButton(onPressed: (){
                  updateChanges();

                }, child: Text("Modifier"))
                // Ajoutez cette partie sous le bouton "Modifier"
                ,
                Padding(padding: EdgeInsets.only(top: 25,bottom: 16,left: 16,right: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star, // Utilisez l'icône de votre choix
                        color: Colors.yellow, // Couleur de l'icône
                        size: 30, // Taille de l'icône
                      ),
                      SizedBox(width: 10), // Espace entre l'icône et le texte
                      Text(
                        "Trophées",
                        style: TextStyle(fontSize: 35),
                      ),
                    ],
                  ),
                )
                ,
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    height: 100, // Ajustez la hauteur en fonction de votre mise en page
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trophies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80, // Ajustez la largeur en fonction de votre mise en page
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue, // Couleur de fond du trophée
                            ),
                            child: Center(
                              child: Text(
                                trophies[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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

  Future chooseImage(ImageSource source) async{
    XFile? file = await picker.pickImage(source: source,imageQuality: 10);
    if(file != null){
      setState(() {
        image = File(file!.path);

      });
    }

  }

  void updateChanges() async{

    bool textModif = false;
    bool imageModif = false;

    //update pseudo si il est différent

    //changer shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();


    if(_currentPseudo != prefs.getString("username")){
      print("update pseudooo");
      prefs.setString("username", _currentPseudo);

      //changer firestore
      User_repository user_rep = new User_repository();
      String? idUser = prefs.getString("userId");
      if(idUser != ""){
        textModif = true;
        user_rep.updateUserPseudo(idUser!, _currentPseudo).then((value){

          print("avant poppp");
          if(image == null){
            Navigator.pop(context,"data");
            textModif = true;
          }


        });
      }
    }
    else{
      print("pseudo non changé");
    }

    //update image si changé

    if(image != null){
      print("update image");

      Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingPage()),);


      User_repository user_rep = User_repository();
      if(prefs.getString("userId") != null){
        String? userImagePath = await user_rep.getUserImagePath(prefs.getString("userId")!);

        if(userImagePath != null){

          Storage_service storage_service = Storage_service();
          //delete ancienne image
          storage_service.deleteFile(userImagePath);

          //upload new image
          imageModif = true;
          storage_service.uploadFileFromAllPath(image!, userImagePath).then((value){

            //delete ancienne image du cache
            CachedFirestorage.instance.removeCacheEntry(mapKey: userImagePath);

            //fermer la page et recharger la page menu



            Navigator.pop(context);
            Navigator.pop(context,"data");

            //RELOAD APP

          });





        }

      }

    }
    else{
      print("image non changée");



    }

    if(!textModif && !imageModif){
      if(_currentPseudo == prefs.getString("username")){
        //rien n'a changé
        Navigator.pop(context);
      }
    }

  }

}
