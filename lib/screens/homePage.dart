//import 'dart:html';
import 'dart:ui';

import 'package:custom_clippers/Clippers/sin_cosine_wave_clipper.dart';
import 'package:custom_clippers/enum/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cbap_prep_app/services/dbReference.dart';
import 'package:cbap_prep_app/routes.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:numberpicker/numberpicker.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    int questionCount = 1;
    int startIndex = 1;

    //TODO pull from SharedPreferences
    String selectedDb = "CBAP";

    OutlinedButton quickStartButton = new OutlinedButton(
      child: Text(
        'Quick Start',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      style: ButtonStyle(
//        side: MaterialStateProperty.all<BorderSide>(
//            BorderSide(color: Theme.of(context).primaryColor)),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(1),
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Configure Test'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Number of questions:',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  NumberPicker(
                    axis: Axis.horizontal,
                    minValue: 1,
                    maxValue: numQuestionsInBank,
                    value: questionCount,
                    onChanged: (value) {
                      setState(() => questionCount = value);
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
//                int questionCount = int.parse(questionCountController.text);
                Navigator.pop(context, 'Start');
//                await Navigator.pop(context, 'Start');
                Navigator.pushNamed(context, questionsRoute, arguments: [
                  'Question Page',
                  0,
                  questionCount,
                  TestType.Random
                ]);
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );

    OutlinedButton customStartButton = new OutlinedButton(
      child: Text(
        'Custom Start',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      style: ButtonStyle(
//        side: MaterialStateProperty.all<BorderSide>(
//            BorderSide(color: Theme.of(context).primaryColor)),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(1),
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Configure Test'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question number to start from:",
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.left,
                  ),
                  NumberPicker(
                    minValue: 1,
                    axis: Axis.horizontal,
                    maxValue: numQuestionsInBank,
                    value: startIndex,
                    onChanged: (value) {
                      setState(() => startIndex = value);
                      print("startIndex: $startIndex");
                    },
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Number of Questions:",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  NumberPicker(
                    axis: Axis.horizontal,
                    minValue: 1,
                    maxValue: numQuestionsInBank - startIndex + 1,
                    value: questionCount,
                    onChanged: (value) {
                      setState(() => questionCount = value);
                      print("questionCount: $questionCount");
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Start');
//                await Navigator.pop(context, 'Start');
                Navigator.pushNamed(context, questionsRoute, arguments: [
                  'Question Page',
                  startIndex,
                  questionCount,
                  TestType.Random
                ]);
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );

    IconButton settingsButton = new IconButton(
      icon: Icon(Icons.settings),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Settings'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question Database:",
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.left,
                  ),
                  DropdownButton(
                    items: [
                      DropdownMenuItem<String>(
                          child: Text('CBAP'), value: 'CBAP'),
                      DropdownMenuItem<String>(
                          child: Text('CISA'), value: 'CISA'),
                    ],
                    value: selectedDb,
                    onChanged: (value) {
                      setState(() {
                        selectedDb = value;
                      });
                      print(selectedDb);
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                //TODO write to SharedPreferences then pop
                Navigator.pop(context, 'OK');
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Test Prep App"),
        actions: [
          settingsButton,
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.53,
                width: double.infinity,
//                color: Colors.redAccent,
                child: ClipPath(
                  clipper: SinCosineWaveClipper(
                    horizontalPosition: HorizontalPosition.LEFT,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.cyan[100],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.53,
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 10.0),
                child: ClipPath(
                  clipper: SinCosineWaveClipper(
                    horizontalPosition: HorizontalPosition.RIGHT,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan[900],
                          Colors.cyan[300],
                        ],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: SvgPicture.asset(
                        "assets/books stack.svg",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Container(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: quickStartButton,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: customStartButton,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
