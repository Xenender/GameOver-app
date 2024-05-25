
/*

To test:
flutter test test/widgetTest/NamePage_test.dart


*/


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameover_app/firebase_options.dart';
import 'package:gameover_app/home/AvatarPage.dart';
import 'package:gameover_app/home/NamePage.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:gameover_app/repository/User_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:integration_test/integration_test.dart';


import 'NamePage_test.mocks.dart';

@GenerateMocks([User_repository],customMocks: [MockSpec<NavigatorObserver>(onMissingStub: OnMissingStub.returnDefault)
])
void main() {

  MockUser_repository mockUser_repository = MockUser_repository();






  setUpAll(() async {

  });



  testWidgets('NamePage UI Test', (WidgetTester tester) async {
    // Build the NamePage widget
    await tester.pumpWidget(MaterialApp(
      home: NamePage(),
    ));

    // Find the text field widget
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    // Find the ElevatedButton widget
    final elevatedButtonFinder = find.byType(ElevatedButton);
    expect(elevatedButtonFinder, findsOneWidget);
  });

  testWidgets('NamePage Input No Name Test', (WidgetTester tester) async {
    // Build the NamePage widget
    await tester.pumpWidget(MaterialApp(
      home: NamePage(),
    ));
    // Find the text field widget
    final textFieldFinder = find.byType(TextField);
    // Enter an empty name
    await tester.enterText(textFieldFinder, '');
    await tester.tap(find.text('Suivant'));
    await tester.pump();
    // Find the error text widget
    expect(find.text('Veuillez choisir un pseudo'), findsOneWidget);
    // Since we're not mocking the user repository, we can't assert navigation here
    // We would typically mock the repository and verify that navigation occurs
  });

  testWidgets('NamePage Input Validation Test', (WidgetTester tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    NavigatorObserver navigatorObserver = NavigatorObserver();

    when(mockObserver.navigator).thenAnswer((_) => null);

    await tester.pumpWidget(MaterialApp(
      home: NamePage(user_repositoryParam: mockUser_repository,),
      navigatorObservers: [mockObserver],

    ));

    when(mockUser_repository.allUser()).thenAnswer((_) async => []);
    await tester.enterText(find.byType(TextField), 'TestUser');
    await tester.tap(find.text('Suivant'));
    await tester.pump();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));
  });


  testWidgets('NamePage Input name already use Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: NamePage(user_repositoryParam: mockUser_repository,),
    ));

    when(mockUser_repository.allUser()).thenAnswer((_) async => [User_model(username: "User1", score: 10),User_model(username: "TestUser", score: 1000)]);
    await tester.enterText(find.byType(TextField), 'TestUser');
    await tester.tap(find.text('Suivant'));
    await tester.pump();

    expect(find.text("Ce pseudo est déjà utilisé"), findsOneWidget);
  });

}
