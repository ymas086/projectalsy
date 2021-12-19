import 'package:cbap_prep_app/screens/resultsHistoryPage.dart';
import 'package:flutter/material.dart';
import 'package:cbap_prep_app/screens/homePage.dart';
import 'package:cbap_prep_app/screens/questionPage.dart';
import 'package:cbap_prep_app/screens/resultsPage.dart';

const String homeRoute = "/";
const String questionsRoute = "/questions";
const String resultsRoute = "/results";
const String resultsHistoryRoute = "/resultsHistory";

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    List data = settings.arguments;
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
            settings: (RouteSettings(
              name: homeRoute,
            )),
            builder: (_) => MyHomePage());
      case questionsRoute:
        return MaterialPageRoute(
            builder: (_) => QuestionPage(
                  title: data[0],
                  startIndex: data[1],
                  numQuestions: data[2],
                  testType: data[3],
                ));
      case resultsRoute:
        return MaterialPageRoute(builder: (_) => ResultsPage(result: data[0]));
      case resultsHistoryRoute:
        return MaterialPageRoute(builder: (_) => ResultsHistoryPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
