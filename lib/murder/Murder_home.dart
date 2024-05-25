import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/murder/MurderHint.dart' if(dart.library.html) 'package:gameover_app/murder/MurderHint_WEB.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../animations/ScrollBehavior1.dart';

class MurderHome extends StatefulWidget {
  @override
  _MurderHomeState createState() => _MurderHomeState();
}

class _MurderHomeState extends State<MurderHome> {
  // Exemple de liste de personnages avec horaires
  final List<List<String>> charactersData = [
    ["ULREICH", "13h-19h"],
    ["Nonline", "13h-19h"],
    ["Eklyn", "13h-19h"],
    ["Lara Croft", "13h-19h"],
    ["Bravo 11", "13h-19h"],
    ["Docteur Richards", "13h-19h"],
    ["Régis", "13h-19h"],
    ["Nithral", "13h-19h"],
    ["Doc'", "13h-19h"],
    // Ajoutez d'autres personnages ici
  ];

  late SharedPreferences? prefs = null;
  final TextEditingController _characterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Charger les préférences partagées
  _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      // Rafraîchir l'état après le chargement des préférences
    });
  }

  // Gérer le changement de l'état de la checkbox
  _handleCheckboxChange(String character) {
    bool currentValue = prefs!.getBool(character) ?? false;
    setState(() {
      prefs!.setBool(character, !currentValue);
    });
  }

  // Afficher le dialogue de confirmation
  _showConfirmationDialog(String character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
            'Voulez-vous vraiment confirmer votre réponse ?\nCeci est votre seul essai, vous ne pourrez plus changer par la suite.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Implémentez l'action à effectuer lors de la confirmation ici
                print('Confirmation pour le personnage : $character');
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  // Naviguer vers la page d'indices
  void _goToIndicePage() {
    // Implémentez la navigation vers la page d'indices ici
    print('Ouverture de la page d\'indices');
    if(!kIsWeb){//mobile

      showModalBottomSheet(



        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        context: context,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.80, // Définissez la hauteur maximale souhaitée
        ),
        isScrollControlled:true,
        builder: (context) {

          return ScrollConfiguration(
            behavior: ScrollBehavior1(), // Utilisez un ScrollBehavior personnalisé
            child: MurderHint(),
          );
        },
      );

    }

    else{//web

      showModalBottomSheet(



        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        context: context,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.80, // Définissez la hauteur maximale souhaitée
        ),
        isScrollControlled:true,
        builder: (context) {

          return ScrollConfiguration(
            behavior: ScrollBehavior1(), // Utilisez un ScrollBehavior personnalisé
            child: MurderHint(),
          );
        },
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    if(prefs != null){
      return Scaffold(

        body:
        Padding(padding: EdgeInsets.only(top: 50),child:
        Column(
          children: [
            // Bouton pour ouvrir la page d'indices
            Padding(padding: EdgeInsets.all(20),
              child:
              ElevatedButton(
              onPressed: () {
                _goToIndicePage();
              },
              child:
              Container(
                width: 200,

                child:   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help,color: Colors.white,), // Icône d'aide comme exemple
                    SizedBox(width: 8),
                    Text("Vos indices",style: TextStyle(color: Colors.white,fontSize: 18),),
                  ],
                ),
              ),





            ) ,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: charactersData.length,
                itemBuilder: (BuildContext context, int index) {
                  final character = charactersData[index][0];
                  final schedule = charactersData[index][1];
                  final isChecked = prefs!.getBool(character) ?? false;

                  return ListTile(
                    title:
                    Row(
                      children: [
                        Text('$character - $schedule'),
                        Spacer(),
                        Transform.scale(
                          scale: 1.25,
                          child:  Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              _handleCheckboxChange(character);
                            },
                          ),
                        )

                      ],
                    ),
                    onTap: () {
                      // Action à effectuer lorsqu'on clique sur un élément
                      print('Nom associé à la case : $character');
                      _handleCheckboxChange(character);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _characterController,
                      decoration: InputDecoration(
                        hintText: 'Qui est le meurtrier ?',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String enteredCharacter = _characterController.text;
                      if (enteredCharacter.isNotEmpty) {
                        _showConfirmationDialog(enteredCharacter);
                      }
                    },
                    child: Text("Confirmer",style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),
                ],
              ),
            ),
          ],
        )
          ,)

      );
    }
    else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
