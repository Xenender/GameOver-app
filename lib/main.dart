
import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gameover_app/animations/LoadingPage.dart';
import 'package:gameover_app/home/NamePage.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:gameover_app/repository/User_repository.dart';
import 'package:gameover_app/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'home/Page1.dart';
import 'hub/Hub.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  print("inside MAIn");
  print(DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CachedFirestorage.instance.cacheTimeout = 900;


  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      title: "GameOverApp",
      debugShowCheckedModeBanner: false,
      home:
        FutureBuilder<Widget>(
          future: chooseFirstPage(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage(); // En attendant la résolution de la future
          } else if (snapshot.hasError) {
          print('Erreur : ${snapshot.error}');
          return Center(child: Text("Erreur, veuillez relancer l'application"),);
          } else {
          return snapshot.data??Center(child: Text("Erreur, veuillez relancer l'application"));
          }
        },
        )
    );

  }


  Future<Widget> chooseFirstPage() async {
    bool isconnected = await userConnected();
    if(isconnected){

      return Hub();
    }
    else{
      return NamePage();
    }
  }

  Future<bool> userConnected() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("userId") != null){

      User_repository user_rep = User_repository();
      List<User_model> userList = await user_rep.allUser();
      bool userExist = false;
      for(User_model model in userList){
        if(model.id == prefs.getString("userId")){
          userExist = true;
        }
      }
      if(userExist){
        return true;
      }
      else{//l'user n'existe pas dans la bdd on le supprime
        prefs.remove("userId");
        prefs.remove("username");
        return false;
      }
    }
    else{
      return false;
    }

  }
}

