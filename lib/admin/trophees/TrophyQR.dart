import 'package:flutter/material.dart';
import 'package:gameover_app/repository/trophy/Trophy_model.dart';
import 'package:gameover_app/repository/trophy/Trophy_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../repository/qr/Qr_model.dart';
import '../../repository/qr/Qr_repository.dart';



class TrophyQR extends StatefulWidget {

  String _id = "";

  TrophyQR(String id){
    _id = id;
  }

  @override
  _QTrophyQRState createState() => _QTrophyQRState(_id);
}

class _QTrophyQRState extends State<TrophyQR> {
  bool _generating = false;
  String _qrCodeData = "0";
  String _randomQRCode = '';


  String _id_trophy = "";

  _QTrophyQRState(String id){
    _id_trophy  = id;
  }

  @override
  void initState() {
    super.initState();

    initVariables();


  }

  void initVariables () async {
    Trophy_repository rep = Trophy_repository();
    Trophy_model trophy = await rep.getTrophyFromId(_id_trophy);
    setState(() {
      _qrCodeData = (trophy.code??"0") ;
    });


  }

  @override
  void dispose() {
    // Exécutez votre code ici avant de quitter la page
    print("fermeture app");
    if (_randomQRCode.isNotEmpty) {
      Qr_repository rep = Qr_repository();
      rep.deleteQrById(_randomQRCode);
      _randomQRCode = '';
    }

    super.dispose();
  }

  void _generateQRCode(String id_qr) {
    _randomQRCode = id_qr;
    _generating = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Générateur de QR Code'),
        ),
        body: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              // Partie supérieure (70%)
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Center(
                  child: _randomQRCode.isEmpty
                      ? Text("Aucun QR Code généré")
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Code de validation du trophée", style: TextStyle(fontSize: 20),),
                      QrImageView(
                        data: _randomQRCode,
                        version: QrVersions.auto,
                        size: 300.0,
                      ),
                    ],
                  ),
                ),
              ),
              // Partie inférieure (30%)
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    ElevatedButton(
                      onPressed: () {
                        print(_qrCodeData);
                        print(_generating);
                        print(_randomQRCode);
                        if (_qrCodeData != "0" && !_generating) {
                          _generating = true;
                          if (_randomQRCode.isNotEmpty) {
                            Qr_repository rep = Qr_repository();
                            rep.deleteQrById(_randomQRCode);
                            _randomQRCode = '';
                          }
                          Qr_model qr_code = Qr_model(xp: _qrCodeData,titre: "ajout d'un trophée");
                          sendDataAndGenerateCode(qr_code);
                        }
                      },
                      child: Text("Générer",style: TextStyle(color: Colors.white,fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          ) ,
        )


    );
  }

  void sendDataAndGenerateCode(Qr_model qr_code) async {
    Qr_repository rep = Qr_repository();
    String idQr = await rep.createQr(qr_code); // Envoyer les données à Firestore
    _generateQRCode(idQr);
  }
}
