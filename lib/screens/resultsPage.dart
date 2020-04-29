import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:project_alsy/routes.dart';

class ResultsPage extends StatelessWidget {
  ResultsPage({Key key, this.numCorrect, this.totalQuestionCount});

  final int numCorrect;
  final int totalQuestionCount;

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
                valueColor: AlwaysStoppedAnimation(Colors.purple[500]),
                backgroundColor: Colors.purple[100],
                // Defaults to the current Theme's backgroundColor.
                center: Text("${(numCorrect * 100 ~/ totalQuestionCount)}%",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[100],
                ),),
              ),
            ),
          ),
          FlatButton(
            child: Text('Return to Home Screen'),
            color: Colors.purple,
            textColor: Colors.grey[100],
            onPressed: () {
              //return to the home screen
              Navigator.popUntil(context, ModalRoute.withName(homeRoute));
            },
          )
        ],
      ),
    );
  }
}
