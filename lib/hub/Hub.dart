
import 'package:flutter/material.dart';
import 'package:gameover_app/QrCode/QRScannerPage.dart';
import 'package:gameover_app/global/GlobalVariable.dart';
import 'package:gameover_app/hub/HubEvents.dart';
import 'package:gameover_app/leaderboard/LeaderBoardScreen.dart';
import 'package:gameover_app/leaderboard/LeaderGPT.dart';
import 'package:gameover_app/leaderboard/Leaderboard.dart';
import 'package:gameover_app/repository/Storage_service.dart';
import 'dart:io';

import 'package:gameover_app/repository/User_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/User_model.dart';




class Hub extends StatefulWidget {
  @override
  State<Hub> createState() => _HubState();
}


class _HubState extends State<Hub>{


  int _nav_selected_index = 0;
  List<Widget> _widgetOptions = <Widget>[
    HubEvents(),
    LeaderGPT(),
    QRScannerPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      try{
        if (index != 0 && GlobalVariable.toolContext != null ) {
          Navigator.of(GlobalVariable.toolContext!).pop(); // Fermez le menu de paramètres spécifique
          GlobalVariable.toolContext = null;
        }
      }
      catch (e){
        print(e);
      }

      _nav_selected_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard),label: "LeaderBoard"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code),label: "Scanner")
        ],
        currentIndex: _nav_selected_index,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),


      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => _widgetOptions[_nav_selected_index],
          );
        },
      ),


    );
  }
}