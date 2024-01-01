import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/Variable_globale.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';



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

                        onTap: prefs!.getBool("indice$key")??false ?
                            (){
                          print("indice numero $key cliqué !");
                          print("dans le else");
                          String path = "";
                          fromAsset('assets/indice$key.pdf', 'indice$key.pdf').then((f) {
                            setState(() {
                              path = f.path;
                              print("after");
                              print(path);
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                builder: (context) => PdfViewer(path),
                              ),);
                            });
                          });

                          print("fast");

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

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

}







class PdfViewer extends StatelessWidget {
  final String pdfAsset;

  PdfViewer(this.pdfAsset);

  late PDFViewController pdfViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfAsset,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onRender: (pages) {
          // Callback when PDF is rendered
        },
        onPageError: (page, error) {
          // Callback when there is an error rendering a page
        },
      ),
    );
  }
}
