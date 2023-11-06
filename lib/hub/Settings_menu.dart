import 'package:flutter/material.dart';
import 'package:gameover_app/admin/AdminHub.dart';

import 'package:url_launcher/url_launcher.dart';

class Settings_menu extends StatelessWidget {


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
                      final Uri url = Uri.https('www.google.com');
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
                    child: ElevatedButton(
                      onPressed: () {

                        String userCode = _codeController.text;
                        if (userCode == "admin") {
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



                        } else {
                          // Le code est incorrect, affichez un message d'erreur
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Code incorrect.'),
                            ),
                          );
                        }
                      },
                      child: Text('Valider'),
                    ),
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
}
