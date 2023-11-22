import 'package:flutter/material.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/Activity_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../repository/qr/Qr_model.dart';
import '../repository/qr/Qr_repository.dart';

class QRGenerator extends StatefulWidget {
  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  bool _generating = false;
  int _qrCodeData = 0;
  String _randomQRCode = '';
  int _qrCodeDataShow = 0;

  TextEditingController _controller = TextEditingController();
  List<String> listeActivitySuggestion = [];

  @override
  void initState() {
    super.initState();

    initVariables();


  }

  void initVariables () async {
    Activity_repository acti_rep = Activity_repository();
    List<Activity_model> listeActivity = await acti_rep.allActivity();
    List<String> listeActivityName = [];
    for(Activity_model a in listeActivity){
      listeActivityName.add(a.titre??"");
    }
    setState(() {
      listeActivitySuggestion = listeActivityName;
    });
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
    _qrCodeDataShow = _qrCodeData;
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
                    Text("${_qrCodeDataShow}xp", style: TextStyle(fontSize: 50),),
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
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Nombre d'XP"),

                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _qrCodeData = int.tryParse(value)!;
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: 'Intitulé',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                _showSuggestions();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_qrCodeData != 0 && !_generating && _controller.text != "") {
                        _generating = true;
                        if (_randomQRCode.isNotEmpty) {
                          Qr_repository rep = Qr_repository();
                          rep.deleteQrById(_randomQRCode);
                          _randomQRCode = '';
                        }
                        Qr_model qr_code = Qr_model(xp: _qrCodeData.toString(),titre: _controller.text);
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
          itemCount: listeActivitySuggestion.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(listeActivitySuggestion[index]),
              onTap: () {
                // Mettez à jour le champ de texte avec la suggestion sélectionnée
                _controller.text = listeActivitySuggestion[index];
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
