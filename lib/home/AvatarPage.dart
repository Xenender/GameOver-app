import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gameover_app/global/GlobalVariable.dart';
import 'package:gameover_app/hub/Hub.dart';
import 'package:gameover_app/repository/Storage_service.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gameover_app/repository/User_repository.dart';
import 'package:gameover_app/repository/User_model.dart';
import '../animations/LoadingPage.dart';

class AvatarPage extends StatefulWidget {
  final String name;

  AvatarPage(this.name);

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  final ImagePicker picker = ImagePicker();
  File? image;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child:

                    GestureDetector(
                      onTap: (){
                        chooseImage(ImageSource.gallery);
                      },
                      child: profilePick(),
                    )

              ),


              isError
                  ? Text("Veuillez choisir une image pour valider",
                  style: TextStyle(color: Colors.red))
                  : Container(),


              Container(
                width: MediaQuery.of(context).size.width/2,
                child: ElevatedButton(
                  onPressed: () {
                    if (image != null) {
                      User_model user = User_model(username: widget.name, score: 0);
                      sendDataAndPushPage(user);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoadingPage(),
                        ),
                      );
                    } else {
                      setState(() {
                        isError = true;
                      });
                    }
                  },
                  child: Text("Suivant",style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
              )


            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){


                    User_model user = User_model(username: widget.name, score: 0);
                    sendDataAndPushPageSKIP(user);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoadingPage(),
                      ),
                    );


                  },
                  child: Text("Ignorer l'étape"),
                ),

                PageViewDotIndicator(
                  currentItem: 1,
                  count: 2,
                  unselectedColor: Colors.black26,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  duration: const Duration(milliseconds: 200),
                  boxShape: BoxShape.circle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future chooseImage(ImageSource source) async {
    XFile? file = await picker.pickImage(source: source, imageQuality: GlobalVariable.profileQuality);
    if (file != null) {
      setState(() {
        image = File(file.path);
        isError = false;
      });
    }
  }

  void sendDataAndPushPage(User_model user) async {
    User_repository rep = User_repository();
    String idUser = await rep.createUser(user); // send data to Firestore

    if (idUser.isNotEmpty) {
      Storage_service storage_service = Storage_service();
      storage_service.uploadFile(image!, idUser).then((value) {
        print("Upload done!");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Hub()),
        );
      });
    }
  }

  void sendDataAndPushPageSKIP(User_model user) async {
    User_repository rep = User_repository();
    String idUser = await rep.createUser(user); // send data to Firestore



        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Hub()),
        );

  }

  Widget profilePick() {
    if (image == null) {
      return Image.asset("lib/images/no-image-icon-23485.png", scale: 4);
    } else {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(image!),
        radius: 50,
      );
    }
  }
}