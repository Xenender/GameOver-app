import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/User_model.dart';
import '../repository/User_repository.dart';
import '../repository/qr/Qr_model.dart';
import '../repository/qr/Qr_repository.dart';

class QR_afterScan extends StatefulWidget {

  String _code="";

  QR_afterScan(this._code);

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
    Qr_repository rep = Qr_repository();
    int nbXp = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Qr_model> listQrModel = await rep.allQr();
    for (var element in listQrModel) {
      if(element.id == _code){
        //code valide
        nbXp = element.xp??0;

        User_repository rep = User_repository();

        rep.addToUserScore(prefs.getString("userId")??"", nbXp);


        //supprimer le code de firebase


        Qr_repository Qrrep = Qr_repository();
        Qrrep.deleteQrById(_code);
        _code = '';

      }
    }


  return Text(

    nbXp == 0 ? "QR code non valide..." : "Youpi ! Vous gagnez ${nbXp}xp !",
    style: TextStyle(fontSize: 24.0),
  );
  }
}
