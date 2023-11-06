import 'package:flutter/material.dart';
import 'package:gameover_app/home/AvatarPage.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../animations/SlidePageRoute.dart';
import '../leaderboard/Leaderboard.dart';
class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {

  String? _name;

  @override
  Widget build(BuildContext context) {
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
                      _name=e;
                      print(_name);
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: "Votre nom"),
                  )
                ),


                ElevatedButton(
                  onPressed: ((){

                    if(_name != null && _name != ""){
                      Navigator.push(
                        context,
                        SlidePageRoute(page:AvatarPage(_name!)),
                      );
                    }

                  }),
                  child: Text("Suivant",style: TextStyle(color: Colors.white),),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          )
                      )
                      ,backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue)
                  ),
                ),
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
                            selectedColor: Colors.blue,
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

