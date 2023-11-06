import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Page2.dart'; // Importez la page suivante
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import '';

import 'package:gameover_app/repository/User_model.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: ElevatedButton(onPressed: (){
        User_model user = User_model(username: "val",score: 0);
        sendData(user);
      },
      child: Text("send data"),)
    );
  }

  final _db = FirebaseFirestore.instance;

  createUser(User_model user) async {
    await _db.collection("users").add(user.toJson()).whenComplete(() => print("info envoyées")).catchError((error){print("une ererur:$error");});
  }

  void sendData(User_model user){
    print("user recup");
    print(user);
    print(user.toJson());
    createUser(user);
    print("data sentttt");
  }
}
