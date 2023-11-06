import 'package:flutter/material.dart';
import 'package:gameover_app/admin/CreateActivity.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/Activity_repository.dart';

import 'UpdateActivity.dart';

class ActivityManagerPage extends StatefulWidget {
  @override
  _ActivityManagerPageState createState() => _ActivityManagerPageState();
}

class _ActivityManagerPageState extends State<ActivityManagerPage> {
  Future<List<List<String>>>? activities;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    activities = getAllActivitiyNameAndId();


    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des activités'),
      ),
      body: FutureBuilder<List<List<String>>>(
        future: activities,
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
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Ajoutez ici votre logique pour la modification
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateActivity(snapshot.data![index][1]))).then((value){
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateActivity())).then((value){
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

  Future<List<List<String>>> getAllActivitiyNameAndId() async{

    List<List<String>> allActivityNames = [];
    Activity_repository repo = Activity_repository();
    List<Activity_model> lstModelActivity = await repo.allActivity();

    for(var element in lstModelActivity){
      allActivityNames.add([element.titre??"",element.id??""]);
    }


    return allActivityNames;
  }

}
