
import 'package:flutter/material.dart';
import 'package:gameover_app/repository/Storage_service.dart';
import 'dart:io';

import 'package:gameover_app/repository/User_repository.dart';

import '../repository/User_model.dart';

import 'package:cached_network_image/cached_network_image.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard ({super.key});

  @override
  Widget build(BuildContext context) {
    Storage_service storage = Storage_service();
    return Scaffold(

        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 40,horizontal: 20),
            child: Column(
              children: [
                FutureBuilder<Column>(
                  future: leaderBoard(),
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


        );
  }



  Future<Column> leaderBoard() async{
    User_repository rep = User_repository();
    Storage_service storage = Storage_service();

    List<User_model> listUserModel = await rep.allUser();
    List<Row> lstRow = [];
    listUserModel.forEach((element) {
      print("url downlaod:");
      print(element.pdp);


      FutureBuilder futureImage = FutureBuilder<String>(
        future: storage.downloadURL(element.pdp!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // En attendant la résolution de la future
          } else if (snapshot.hasError) {
            print('Erreur : ${snapshot.error}');
            return Container(width: 0,height: 0,);
          } else {
            return Container(width: 100,height: 100, child: CachedNetworkImage(imageUrl:snapshot.data!,fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),),);
          }
        },
      );

      lstRow.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [futureImage,Text(element.username??"nada"),Text(element.score.toString())])

      );
    });
    return Column(children: lstRow);
  }
}
