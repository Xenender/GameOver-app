import 'package:flutter/material.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/Activity_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../global/Variable_globale.dart';
import '../../repository/qr/Qr_model.dart';
import '../../repository/qr/Qr_repository.dart';


class MurderQr extends StatefulWidget {
  @override
  _MurderQrState createState() => _MurderQrState();
}

class _MurderQrState extends State<MurderQr> {

  bool _generating = false;

  String _randomQRCode = '';


  TextEditingController _controller = TextEditingController();
  List<String> listeSuggestion = indices.values.toList();



  int dropdownSelectedValue = 1;


  @override
  void initState() {
    super.initState();

  }



  @override
  void dispose() {
    // Exécutez votre code ici avant de quitter la page
    print("fermeture app");
    if (_randomQRCode.isNotEmpty) {
      Qr_repository rep = Qr_repository();
      rep.deleteQrById(_randomQRCode);
      _randomQRCode = '';
    }

    super.dispose();
  }

  void _generateQRCode(String id_qr) {
    _randomQRCode = id_qr;
    _generating = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Générateur de QR Code'),
        ),
        body: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              // Partie supérieure (70%)
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Center(
                  child: _randomQRCode.isEmpty
                      ? Text("Aucun QR Code généré")
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      QrImageView(
                        data: _randomQRCode,
                        version: QrVersions.auto,
                        size: 300.0,
                      ),
                    ],
                  ),
                ),
              ),
              // Partie inférieure (30%)
              Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          DropdownButton<int>(
                            value: dropdownSelectedValue,
                            onChanged: (int? newValue) {
                              setState(() {
                                dropdownSelectedValue = newValue!;
                                print("Selected key: $dropdownSelectedValue");
                              });
                            },
                            items: indices.entries.map((MapEntry<int, String> entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (!_generating) {
                          _generating = true;
                          if (_randomQRCode.isNotEmpty) {
                            Qr_repository rep = Qr_repository();
                            rep.deleteQrById(_randomQRCode);
                            _randomQRCode = '';
                          }
                          Qr_model qr_code = Qr_model(xp: "indice$dropdownSelectedValue",titre: "${indices[dropdownSelectedValue]}");
                          sendDataAndGenerateCode(qr_code);
                        }
                      },
                      child: Text("Générer"),
                    ),
                  ],
                ),
              ),
            ],
          ) ,
        )


    );
  }

  void sendDataAndGenerateCode(Qr_model qr_code) async {
    Qr_repository rep = Qr_repository();
    String idQr = await rep.createQr(qr_code); // Envoyer les données à Firestore
    _generateQRCode(idQr);
  }


  void _showSuggestions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: listeSuggestion.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(listeSuggestion[index]),
              onTap: () {
                // Mettez à jour le champ de texte avec la suggestion sélectionnée
                _controller.text = listeSuggestion[index];
                // Fermez la feuille de bottom sheet
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

}
