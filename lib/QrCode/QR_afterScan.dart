import 'package:flutter/material.dart';
import 'package:gameover_app/repository/trophy_user/Trophy_user_model.dart';
import 'package:gameover_app/repository/trophy_user/Trophy_user_repository.dart';
import 'package:gameover_app/repository/user_history/User_history_model.dart';
import 'package:gameover_app/repository/user_history/User_history_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/User_model.dart';
import '../repository/User_repository.dart';
import '../repository/qr/Qr_model.dart';
import '../repository/qr/Qr_repository.dart';

class QR_afterScan extends StatefulWidget {

  String _code="";

  QR_afterScan(this._code){

  }

  @override
  _QR_afterScanState createState() => _QR_afterScanState(_code);
}

class _QR_afterScanState extends State<QR_afterScan> {




  bool valide = false; // Initialisez votre variable de state
  String _code = "";
  Future<Text>? _xpFuture; // Variable pour stocker le résultat de la future

  _QR_afterScanState(this._code);

  @override
  void initState() {
    super.initState();
    _xpFuture = getXp(); // Initialisation de la variable future dans initState

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
            child:
            SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Center(
                    child: FutureBuilder<Text>(
                      future: _xpFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // La future n'est pas encore résolue, affichez un indicateur de chargement
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Gérer les erreurs ici
                          return Text('Erreur: ${snapshot.error}');
                        } else {
                          // La future a été résolue avec succès, affichez le résultat
                          return snapshot.data??Text("QR code non valide...");
                        }
                      },
                    ),
                  ),
                ],
              ) ,
            )

        );
      },
    );
  }

  Future<Text> getXp() async{

    bool isXp = true;
    bool isIndice = false;

    Qr_repository rep = Qr_repository();
    int nbXp = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Qr_model> listQrModel = await rep.allQr();

    for (var element in listQrModel) {


      if(element.id == _code){
        //code valide



        //On teste si c'est un code d'xp ou de trophée

        if(element.xp!.contains("code_")){//code de trophée

          isXp = false;
          isIndice = false;


          String code_trophee = element.xp!;



          //on a l'id du trophee dans code_trophee

          //on ajoute à la table trophy_user la relation user_id, code_trophee

          Trophy_user_model tuModel = Trophy_user_model(user: prefs.getString("userId"), trophy: code_trophee);

          Trophy_user_repository tuRep = Trophy_user_repository();
          tuRep.createTrophy_user(tuModel);

        }
        else{

          if(element.xp!.contains("indice")){//code d'indices
            isXp = false;
            isIndice = true;


            String code_indice = element.xp!;


            //on ajoute la shared pref
            print("code indice ___________________________________");
            print(code_indice);

            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setBool(code_indice, true);
          }
          else{//code d'xp
            isXp = true;
            isIndice = false;

            nbXp = int.parse(element.xp??"0");

            User_repository rep = User_repository();

            String userId = prefs.getString("userId")??"";

            rep.addToUserScore(userId,nbXp);


            //ajouter le code à l'historique

            User_history_repository historyrep = User_history_repository();
            User_history_model historymodel = User_history_model(xp: element.xp??"0", titre: element.titre??"no titre", user: userId);

            historyrep.createHistory(historymodel);
          }


        }

        //supprimer le code de firebase


        Qr_repository Qrrep = Qr_repository();
        Qrrep.deleteQrById(_code);
        _code = '';




      }
    }
    if(_code.contains("indicePERMA_")){
      isXp = false;
      isIndice = true;

      int startIndex = _code.indexOf("indicePERMA_") + "indicePERMA_".length;
      int numero = int.parse(_code.substring(startIndex));


      String code_indice = "indice$numero";

      print("INDICEEQUAL");
      print(code_indice == "indice2");


      SharedPreferences.getInstance().then((prefs){
        prefs.setBool(code_indice, true);

      });



    }

  if(isXp){
    return Text(

      nbXp == 0 ? "QR code non valide..." : "Youpi ! Vous gagnez ${nbXp}xp !",
      style: TextStyle(fontSize: 24.0),
    );
  }
  else{
    if(isIndice){
      return Text(

        "Vous obtenez un indice !",
        style: TextStyle(fontSize: 24.0),
      );
    }
    else{
      return Text(

        "Vous obtenez un trophee !",
        style: TextStyle(fontSize: 24.0),
      );
    }

  }

  }
}
