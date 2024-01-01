import 'package:flutter/material.dart';
import 'package:gameover_app/admin/QRGenerator.dart';
import 'package:gameover_app/admin/admin_murder/MurderQr.dart';
import 'package:gameover_app/admin/trophees/TrophyManagerPage.dart';

import 'ActivityManagerPage.dart';

class AdminHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Pannel admin'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(), // Espace du haut
            ElevatedButton(

              onPressed: () {
                // Action pour "Administrer les événements"
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ActivityManagerPage()));
              },
              child: Text('Administrer les événements'),
            ),
            Spacer(), // Espace entre les boutons

            ElevatedButton(
              onPressed: () {
                // Action pour "Générer un QR code"

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrophyManagerPage()),
                );


              },
              child: Text('Administrer les trophées'),
            ),
            Spacer(),

            ElevatedButton(
              onPressed: () {
                // Action pour "Générer un QR code"

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRGenerator()),
                );


              },
              child: Text("Donner de l'xp"),
            ),
            Spacer(), // Espace du bas


            ElevatedButton(
              onPressed: () {
                // Action pour "Générer un QR code"

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MurderQr()),
                );


              },
              child: Text('Donner un indice (murder)'),
            ),
            Spacer(),
          ],
        ),
      ),

          bottomNavigationBar: null,
    ), onWillPop: () async {
      return true;
    });


  }
}
