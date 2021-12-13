import 'package:cbap_prep_app/services/dbReference.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:cbap_prep_app/routes.dart';

class ResultsPage extends StatelessWidget {
  ResultsPage(
      {Key key, this.numCorrect, this.totalQuestionCount, this.testType});

  final int numCorrect;
  final int totalQuestionCount;
  final TestType testType;

  Widget build(BuildContext context) {
    print("Number of Questions Correct: $numCorrect");
    print("Total Question Count: $totalQuestionCount");
    print("${(numCorrect * 100 ~/ totalQuestionCount)}%");

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
                value: (numCorrect / totalQuestionCount),
                valueColor:
                AlwaysStoppedAnimation(Theme
                    .of(context)
                    .primaryColor),
                center: Text(
                  "${(numCorrect * 100 ~/ totalQuestionCount)}%",
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption,
                ),
                Text(
                  testType == TestType.Random
                      ? "Quick Start Test"
                      : "Custom Test",
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      fontSize: 20),
                ),
                Divider(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  height: 30,
                  thickness: 2,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Column(
                        children: [
                          Text(
                            "Total Attempted:",
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                          ),
                          Text(
                            "$totalQuestionCount",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                      Column(
                        children: [
                          Text(
                            "Total Correct:",
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                          ),
                          Text(
                            "$numCorrect",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
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
