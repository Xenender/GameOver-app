import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final PageController _pageController = PageController(initialPage: 1);
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Importez votre image de profil :'),
            // Votre code pour importer l'image ici
            Text('Passer l\'étape', style: TextStyle(fontSize: 16.0)),
            PageViewDotIndicator(
                currentItem: 1,
                count: 2,
                unselectedColor: Colors.black26,
                selectedColor: Colors.blue,
                duration: const Duration(milliseconds: 200),
                boxShape: BoxShape.rectangle,
                onItemClicked: (index) {
                  _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,);}
            ),
          ],
        ),
      ),
    );
  }
}
