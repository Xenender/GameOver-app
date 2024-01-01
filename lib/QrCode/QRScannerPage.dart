import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'QR_afterScan.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool isCameraActive = true; // Ajoutez un indicateur pour savoir si la caméra est active

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Padding(padding: EdgeInsets.only(bottom: 50),child: Center(
        child: Stack(
          children: <Widget>[
            QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  if (isCameraActive) {
                    // L'action que vous voulez effectuer lorsque le code QR est scanné
                    print('QR code scanné : ${scanData.code}');

                    // Désactive la caméra pour éviter les scans supplémentaires
                    isCameraActive = false;

                    // Déplacez-vous vers une autre page
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {

                        return QR_afterScan(scanData.code??""); // Affichez votre menu de paramètres ici
                      },
                    ).then((value) {

                      print('La feuille inférieure est fermée. La valeur renvoyée est : $value');

                      isCameraActive = true;
                    });
                  }
                });
              },
            ),
            // Container en bas
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 150,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                      color: Colors.white
                  ),


                  child: Center(
                    child: Text('Scannez un QR code généré \n par un administrateur:',textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                  ),
                )
            )



          ],
        ),
      ),)
      ,
    );
  }
}
