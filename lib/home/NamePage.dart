import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gameover_app/home/AvatarPage.dart' if (dart.library.html) 'package:gameover_app/home/AvatarPage_WEB.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:gameover_app/repository/User_repository.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../animations/SlidePageRoute.dart';
import '../leaderboard/Leaderboard.dart';
class NamePage extends StatefulWidget {

  User_repository? user_repositoryParam = null; //FOR TESTS

  NamePage({super.key, this.user_repositoryParam = null});

  @override
  State<NamePage> createState() => _NamePageState(user_repositoryParam: this.user_repositoryParam);
}

class _NamePageState extends State<NamePage> {

  String? _name;
  String? errorText;
  User_repository? user_repositoryParam = null;

  _NamePageState({this.user_repositoryParam = null});

  @override
  Widget build(BuildContext context) {

    print("testBUILD");
    print(user_repositoryParam);

    return Scaffold(
      body: Stack(

        children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 80),
                  child: TextField(
                    onChanged: (e) {
                      if(e.length < 15){
                        _name=e;
                        print(_name);
                      }

                    },
                    maxLength: 15,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Votre pseudo',
                      border: OutlineInputBorder(),

                    ),
                  )
                ),

                errorText!=null?
                    Text(errorText!,style: TextStyle(color: Colors.red),)
                :Container(),


                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  width: MediaQuery.of(context).size.width/2,
                  child: ElevatedButton(
                    onPressed: (() async {

                      print("PREMIERS");


                      if(_name != null && _name != ""){

                        User_repository user_rep;

                        user_repositoryParam != null ? user_rep = user_repositoryParam! : user_rep = User_repository();  //FOR TESTS


                        bool pseudoLibre = true;
                        user_rep.allUser().then((userList){
                          for(var elem in userList){
                            elem.username!.toLowerCase() == _name!.toLowerCase() ? pseudoLibre = false : null;
                          }
                          if(pseudoLibre){

                            errorText = null;
                            Navigator.push(
                              context,
                              SlidePageRoute(page:AvatarPage(_name!)),
                            );
                          }
                          else{
                            setState(() {
                              errorText="Ce pseudo est déjà utilisé";
                            });
                          }

                        });


                      }
                      else{//nom vide
                        setState(() {
                          errorText="Veuillez choisir un pseudo";
                        });
                      }

                    }),
                    child: Text("Suivant",style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),
                )

              ],
              ),

                Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PageViewDotIndicator(
                            currentItem: 0,
                            count: 2,
                            unselectedColor: Colors.black26,
                            selectedColor: Theme.of(context).colorScheme.primary,
                            duration: const Duration(milliseconds: 200),
                            boxShape: BoxShape.circle,

                          ),
                        ],
                      ),
                    )





        ],

      ),
    );
  }
}

