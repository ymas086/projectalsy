import 'package:flutter/material.dart';
import 'package:project_alsy/screens/homePage.dart';
import 'package:project_alsy/screens/questionPage.dart';
import 'package:project_alsy/screens/resultsPage.dart';

const String homeRoute = "/";
const String questionsRoute = "/questions";
const String resultsRoute = "/results";

class Router {
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
                QuestionPage(title: data[0], numQuestions: data[1]));
      case resultsRoute:
        return MaterialPageRoute(
            builder: (_) =>
                ResultsPage(numCorrect: data[0], totalQuestionCount: data[1]));
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
