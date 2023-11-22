import 'package:flutter/material.dart';
import 'package:gameover_app/admin/trophees/CreateTrophy.dart';
import 'package:gameover_app/admin/trophees/TrophyQR.dart';
import 'package:gameover_app/repository/trophy/Trophy_model.dart';

import '../../repository/trophy/Trophy_repository.dart';
import 'UpdateTrophy.dart';

class TrophyManagerPage extends StatefulWidget {
  @override
  _TrophyManagerPageState createState() => _TrophyManagerPageState();
}

class _TrophyManagerPageState extends State<TrophyManagerPage> {
  Future<List<List<String>>>? trophy;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des trophées'),
      ),
      body: FutureBuilder<List<List<String>>>(
        future: getAllTrophyNameAndId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // La future n'est pas encore résolue, affichez un indicateur de chargement
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Gérer les erreurs ici
            return Text('Erreur: ${snapshot.error}');
          } else {
            // La future a été résolue avec succès, affichez le résultat
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index][0]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        IconButton(
                        icon: Icon(Icons.qr_code), // Remplacez "Icons.qr_code" par l'icône de QR code de votre choix
                        onPressed: () {
                          // Ajoutez ici votre logique pour le QR code
                          // Par exemple, vous pouvez ajouter une navigation vers une autre page ici
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TrophyQR(snapshot.data![index][1])));
                        },
                      )
                      ,
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Ajoutez ici votre logique pour la modification

                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTrophy(snapshot.data![index][1]))).then((value){
                            print("dans then2");
                            if(value != null){
                              setState(() {
                                print("dans setState2");
                                //actualiser la page
                              });
                            }
                          });



                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajoutez ici votre logique pour ajouter une activité
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTrophy())).then((value){
            print("dans then");
            if(value != null){
              setState(() {
                print("dans setState");
                //actualiser la page
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<List<String>>> getAllTrophyNameAndId() async{

    List<List<String>> allTrophyNames = [];
    Trophy_repository repo = Trophy_repository();
    List<Trophy_model> lstModelTrophy = await repo.allTrophy();

    for(var element in lstModelTrophy){
      allTrophyNames.add([element.titre??"",element.id??""]);
    }


    return allTrophyNames;
  }

}
