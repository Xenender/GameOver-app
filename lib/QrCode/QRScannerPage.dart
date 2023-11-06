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
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: (controller) {
                  this.controller = controller;
                  controller.scannedDataStream.listen((scanData) {
                    if (isCameraActive) {
                      // L'action que vous voulez effectuer lorsque le code QR est scanné
                      print('Code QR scanné : ${scanData.code}');

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
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text('Scannez un code QR:'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
