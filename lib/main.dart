import 'package:flashcards_for_everything/pages/create_flashcard.dart';
import 'package:flashcards_for_everything/pages/home_page.dart';
import 'package:flashcards_for_everything/pages/play_flashcard.dart';
import 'package:flashcards_for_everything/pages/set_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  runApp(FlashCardApp());
}

class FlashCardApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      theme: ThemeData(
          primaryColor: Color.fromRGBO(26, 35, 126, 1),
          accentColor: Color.fromRGBO(158, 158, 158, 1)),
      title: 'Flutter Demo',
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'CreateFlashCard') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => CreateFlashCard(pathElements[2]),
          );
        }
        if (pathElements[1] == 'SetPage') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => SetPage(pathElements[2]),
          );
        }
        if (pathElements[1] == 'PlayFlashCard') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) =>
                PlayFlashCardPage(pathElements[2]),
          );
        }
      },
      routes: {
        '/': (context) => HomePage(),
        '/PlayFlashCard': (context) => PlayFlashCardPage(''),
        '/CreateFlashCard': (context) => CreateFlashCard(''),
        '/SetPage': (context) => SetPage('')
      },
    );
  }
}
