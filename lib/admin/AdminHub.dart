import 'package:flutter/foundation.dart';
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
            !(kIsWeb) ?
            ElevatedButton(

              onPressed: () {
                // Action pour "Administrer les événements"
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ActivityManagerPage()));
              },
              child: Text('Administrer les événements',style: TextStyle(color: Colors.white,fontSize: 18)),
            ):Container(),
            Spacer(), // Espace entre les boutons

            !(kIsWeb) ?
            ElevatedButton(
              onPressed: () {
                // Action pour "Générer un QR code"

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrophyManagerPage()),
                );


              },
              child: Text('Administrer les trophées',style: TextStyle(color: Colors.white,fontSize: 18)),
            ):Container(),
            Spacer(),

            ElevatedButton(
              onPressed: () {
                // Action pour "Générer un QR code"

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRGenerator()),
                );


              },
              child: Text("Donner de l'xp",style: TextStyle(color: Colors.white,fontSize: 18)),
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
              child: Text('Donner un indice (murder)',style: TextStyle(color: Colors.white,fontSize: 18)),
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
