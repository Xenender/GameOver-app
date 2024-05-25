import 'package:flutter/material.dart';
import 'package:gameover_app/admin/AdminHub.dart';
import 'package:gameover_app/repository/admin_password/AdminPassword_model.dart';
import 'package:gameover_app/repository/admin_password/AdminPassword_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';


class Settings_menu extends StatefulWidget {

  @override
  State<Settings_menu> createState() => Settings_menuState();
}


class Settings_menuState extends State<Settings_menu> {


  final TextEditingController _codeController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: DraggableScrollableSheet(

      initialChildSize: 0.9,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
            color: Colors.white,
            child:
            SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Politique de confidentialité'),
                    onTap: () async{
                      print("fcttt");
                      final Uri url = Uri.https(
                        "doc-hosting.flycricket.io",
                        "/gameover-privacy-policy/6b64b1a0-b770-4b11-aa24-d74aea23d533/privacy",
                      );
                      try{
                        await launchUrl(url);
                      }
                      catch(e){
                        print("erreur ed lancement du site !!!!");
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text("Conditions d'utilisation"),
                    onTap: () async {
                      print("fcttt");
                      final Uri url = Uri.https('www.google.com');
                      try{
                        await launchUrl(url);
                      }
                      catch(e){
                        print("erreur ed lancement du site !!!!");
                      }


                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Entrez un code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Center(
                    child:
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: ElevatedButton(
                        onPressed: () async {

                          print("test");

                          //recuperer le code admin depuis firebase
                          String password = "";

                          AdminPassword_repository adminRep = AdminPassword_repository();



                          AdminPassword_model passwordModel = await adminRep.getAdminPasswordModel();

                          password = passwordModel.password??"no internet";



                          String userCode = _codeController.text;
                          if (userCode == password) {
                            // Le code est correct, effectuez l'action souhaitée ici
                            // Par exemple, affichez un message


                            //rediriger vers la page admin
                            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                              builder: (context) => AdminHub(),
                            ),
                            ).then((value){
                              print("avant reload from tools");
                              Navigator.pop(context,"data");

                            });
                            /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminHub()),
                          ).then((value){
                            print("avant reload from tools");
                            Navigator.pop(context,"data");

                          });

                           */



                          }
                          else if (userCode.contains("ADMINPREF_")) {


                            changePrefCode(userCode);


                          }

                          else {
                            // Le code est incorrect, affichez un message d'erreur
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Code incorrect.'),
                              ),
                            );
                          }
                        },
                        child: Text("Valider",style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                    )
                    ,
                  ),
                ],
              ) ,
            )

        );
      },
    ), onWillPop: () async {
      Navigator.pop(context);
      return false;
    });



  }

  void changePrefCode(String code) async {

    // Trouver l'index du premier et du dernier _
    int premierUnderscoreIndex = code.indexOf("_");
    int dernierUnderscoreIndex = code.lastIndexOf("_");

    // Extraire ce qu'il y a entre le premier _ et le dernier _
    String prefname = code.substring(premierUnderscoreIndex + 1, dernierUnderscoreIndex);

    // Extraire ce qu'il y a après le deuxième _ jusqu'à la fin
    String prefvalue = code.substring(dernierUnderscoreIndex + 1);

    // Afficher les résultats
    print("Entre premier et dernier underscore : $prefname");
    print("Après deuxième underscore jusqu'à la fin : $prefvalue");

    SharedPreferences.getInstance().then((prefs) => prefs.setBool(prefname, prefvalue=='1'));



  }

}
