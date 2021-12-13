import 'package:flutter/material.dart';
import 'package:cbap_prep_app/screens/homePage.dart';
import 'package:cbap_prep_app/screens/questionPage.dart';
import 'package:cbap_prep_app/screens/resultsPage.dart';

const String homeRoute = "/";
const String questionsRoute = "/questions";
const String resultsRoute = "/results";

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
            builder: (_) =>
                QuestionPage(title: data[0],startIndex:data[1], numQuestions: data[2], testType: data[3],));
      case resultsRoute:
        return MaterialPageRoute(
            builder: (_) =>
                ResultsPage(numCorrect: data[0], totalQuestionCount: data[1], testType: data[2]));
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
