
/*

To test:
with an emulator android open -

flutter drive --target=test_driver/app.dart



*/

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main(){
  try {

    group("flutter GameOver app test", (){

      FlutterDriver? driver;

      setUpAll(() async {

        driver = await FlutterDriver.connect();

      });

      tearDownAll((){

        if(driver != null){
          driver!.close();
        }
      });

      test("Enter username", () async{
        var userName = find.byType("TextField");
        var button = find.text("Suivant");

        await driver!.tap(userName);
        await Future.delayed(Duration(seconds: 2));
        await driver!.enterText("UserTest");
        await Future.delayed(Duration(seconds: 2));
        await driver!.tap(button);
        await Future.delayed(Duration(seconds: 2));
      });

      test("Pass choose image page", () async{
        var button = find.text("Ignorer l'étape");

        await Future.delayed(Duration(seconds: 2));
        await driver!.tap(button);
        await Future.delayed(Duration(seconds: 20));

      });

    });

  } on Exception catch (_) {
    print('never reached');
  }

}