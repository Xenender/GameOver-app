import 'package:cached_firestorage/remote_picture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../animations/ScrollBehavior1.dart';
import '../repository/Storage_service.dart';
import '../repository/User_model.dart';
import '../repository/User_repository.dart';
import '../updatedLIBS/remote_picture_up.dart';
import 'Leaderboard_profile_menu.dart';

class User {
  final String id;
  final String name;
  final int score;
  final RemotePictureUp? profileImage;

  User(this.id,this.name, this.score, {this.profileImage});
}

class LeaderGPT extends StatelessWidget {


  List<User> users = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

          body:
          Container(
            padding: EdgeInsetsDirectional.only(top: 60,start: 0,end: 0,bottom: 0),
            child:
            FutureBuilder<List<User>>(
              future: parseBdd(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // En attendant la résolution de la future
                } else if (snapshot.hasError) {
                  print('Erreur : ${snapshot.error}');
                  return Text("Une erreur est survenue...");
                } else {
                  print("DATAAAAAAAAA");
                  print(snapshot.data);



                  List<User>? leaderBoardTrie = snapshot.data;


                  if(snapshot.data == []){
                    leaderBoardTrie = [
                      User('','Utilisateur 1', 100),
                      User('','Utilisateur 2', 90),
                      User('','Utilisateur 3', 80),
                      // Ajoutez d'autres utilisateurs ici
                    ];
                  }



                  leaderBoardTrie!.sort((a,b)=>b.score.compareTo(a.score));

                  return Column(
                    children: [
                      // Podium pour les 3 premiers utilisateurs
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildPodiumItem(leaderBoardTrie[0],context,1),
                            _buildPodiumItem(leaderBoardTrie[1],context,2),
                            _buildPodiumItem(leaderBoardTrie[2],context,3),
                          ],
                        ),
                      ),
                      // Liste des utilisateurs restants
                      Expanded(
                        child:
                        ListView.builder(
                          itemCount: leaderBoardTrie.length - 3, // Exclure les 3 premiers utilisateurs
                          itemBuilder: (context, index) {
                            return _buildLeaderboardItem(leaderBoardTrie![index + 3], index + 4,context);
                          },
                        ),
                      ),

                    ],
                  );
                }
              },
            ),






          ),
        );

  }

  Widget _buildPodiumItem(User user, BuildContext context, int rank) {
    Color borderColor;

    switch (rank) {
      case 1:
        borderColor = Color(0xFFD9B959); // Or
        break;
      case 2:
        borderColor = Colors.grey; // Argent
        break;
      case 3:
        borderColor = Color(0xFFD9805F); // Bronze
        break;
      default:
        borderColor = Colors.transparent; // Pas de contour pour les autres
    }

    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 4.0),
            ),
            child: ClipOval(
              child: user.profileImage ?? Container(height: 0, width: 0),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Xp: ${user.score}'),
        ],
      ),
      onTap: () {
        // Ouvrir la page avec comme paramètre l'utilisateur
        print(user.id);
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          context: context,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.70,
          ),
          isScrollControlled: true,
          builder: (context) {
            return ScrollConfiguration(
              behavior: ScrollBehavior1(),
              child: Leaderboard_profile_menu(user.id),
            );
          },
        );
      },
    );
  }

  Widget _buildLeaderboardItem(User user, int rank,BuildContext context) {
    return
      GestureDetector(
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            child: ClipOval(
              child: user.profileImage,
            ),
          ),
          title: Text(
            '${rank}. ${user.name}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Xp: ${user.score}'),
        ),
        onTap: (){
          print(user.id);
          //ouvrir page avec user comme param

          showModalBottomSheet(



            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            context: context,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.70, // Définissez la hauteur maximale souhaitée
            ),
            isScrollControlled:true,
            builder: (context) {

              return ScrollConfiguration(
                behavior: ScrollBehavior1(), // Utilisez un ScrollBehavior personnalisé
                child: Leaderboard_profile_menu(user.id), // Affichez votre menu de paramètres ici
              );
            },
          );




        },
      );

      ;
  }

  Future<List<User>> parseBdd() async{

    List<User> userReturn = [];

    User_repository rep = User_repository();
    Storage_service storage = Storage_service();

    List<User_model> listUserModel = await rep.allUser();

    for (var element in listUserModel) {
      print("url downlaod:");
      print(element.pdp);

      RemotePictureUp imageDownloadedRound = RemotePictureUp(
        imagePath: element.pdp!,
        placeholder:"lib/images/no-image-icon-23485.png",
        mapKey: element.pdp??'0',
        fit: BoxFit.cover,
      );


      userReturn.add(new User(element.id??'',element.username??"", element.score??0, profileImage: imageDownloadedRound));


    };
    return userReturn;
  }
}
