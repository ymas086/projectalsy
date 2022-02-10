import 'package:cbap_prep_app/models/result.dart';
import 'package:cbap_prep_app/services/dbReference.dart';
import 'package:cbap_prep_app/services/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:cbap_prep_app/routes.dart';

class ResultsPage extends StatelessWidget {
  ResultsPage({Key key, this.result});

  final QuizResult result;
  final DatabaseHelper db = DatabaseHelper.instance;

  Widget build(BuildContext context) {
    print("Number of Questions Correct: ${result.totalCorrect}");
    print("Total Question Count: ${result.totalQuestionCount}");
    print("${(result.totalCorrect * 100 ~/ result.totalQuestionCount)}%");

    db.saveTestResult(this.result);

    return Scaffold(
      appBar: AppBar(
        title: Text('Results Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: SizedBox(
              height: 250,
              width: 250,
              child: LiquidCircularProgressIndicator(
                value: (result.totalCorrect / result.totalQuestionCount),
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                center: Text(
                  "${(result.totalCorrect * 100 ~/ result.totalQuestionCount)}%",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[100],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Text(
                  "Test Type",
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  result.testType == TestType.Random.toString()
                      ? "Quick Start Test"
                      : "Custom Test",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  height: 30,
                  thickness: 2,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Total Attempted:",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            "${result.totalQuestionCount}",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Column(
                        children: [
                          Text(
                            "Total Correct:",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            "${result.totalCorrect}",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
//TODO: Consider including a button that lets you run through all questions in this attempt
          TextButton(
            child: Text('Return to Home Screen'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
//              side: MaterialStateProperty.all<BorderSide>(
//                BorderSide(color: Theme.of(context).primaryColor),
//              ),
              elevation: MaterialStateProperty.all(1),
            ),
            onPressed: () {
              //return to the home screen
              Navigator.popUntil(context, ModalRoute.withName(homeRoute));
            },
          ),
        ],
      ),
    );
  }
}
