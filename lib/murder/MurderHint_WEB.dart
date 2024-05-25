import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'dart:html' as html;

import '../global/Variable_globale.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';




class MurderHint extends StatefulWidget {
  @override
  _MurderHintState createState() => _MurderHintState();
}

class _MurderHintState extends State<MurderHint> {


  late SharedPreferences? prefs = null;


  @override
  void initState() {
    super.initState();
    loadIndicesVisibility();


  }

  void loadIndicesVisibility() async {
    prefs = await SharedPreferences.getInstance();

    /*
    for (int i = 1; i <= indices.length; i++) {
      bool isVisible = prefs.getBool("indice$i") ?? false;
      setState(() {
        indicesVisibility[i - 1] = isVisible;
      });
    }

     */

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if(prefs != null){
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.1,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return

            Column(
              children: [

                Text("Vos indices",style: TextStyle(fontSize: 25),),
                Expanded(child: Container(
                  color: Colors.white,
                  child:
                  ListView(
                    children: indices.entries.map((entry) {
                      int key = entry.key;
                      String value = entry.value;
                      return ListTile(
                          title:
                          prefs!.getBool("indice$key")??false ?
                          Text(
                            value,
                            style: TextStyle(fontSize: 16),
                          )

                              :

                          Text(
                            "?????",
                            style: TextStyle(fontSize: 16),
                          ),

                          onTap:

                          prefs!.getBool("indice$key")??false ?
                              (){

                               previewPDFFile("https://firebasestorage.googleapis.com/v0/b/game-over-mobile-app.appspot.com/o/indices%2Findice$key.pdf?alt=media&token=58f7f783-63f1-42c7-b61d-799bc1d8c0df");

                          }

                              :
                              (){




                          }


                      );
                    }).toList(),
                  ),)
                  ,
                )


              ],
            )

          ;
        },
      );
    }
    else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  downloadFileWeb(String url,String fileName) async {

    final httpsReference = FirebaseStorage.instance.refFromURL(url);

    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await httpsReference.getData(oneMegabyte);
      // Data for "images/island.jpg" is returned, use this as needed.
      XFile.fromData(data!,
          mimeType: "application/octet-stream", name: fileName + ".pdf")
          .saveTo("C:/"); // here Path is ignored
    } on FirebaseException catch (e) {
      // Handle any errors.
    }
    // for other platforms see this solution : https://firebase.google.com/docs/storage/flutter/download-files#download_to_a_local_file
  }
  previewPDFFile(url) {
    html.window.open(url,"_blank"); //opens pdf in new tab
  }
}
