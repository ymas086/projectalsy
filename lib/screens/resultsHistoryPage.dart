import 'dart:async';

import 'package:async/async.dart';
import 'package:cbap_prep_app/models/result.dart';
import 'package:cbap_prep_app/services/dbReference.dart';
import 'package:d_chart/d_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:cbap_prep_app/services/dbhelper.dart';

class ResultsHistoryPage extends StatefulWidget {
  ResultsHistoryPage({Key key}) : super(key: key);

  final DatabaseHelper db = DatabaseHelper.instance;

  @override
  _ResultsHistoryPageState createState() => _ResultsHistoryPageState();
}

class _ResultsHistoryPageState extends State<ResultsHistoryPage> {
  static final DatabaseHelper db = DatabaseHelper.instance;
  Future<List<QuizResult>> resultsQuery;
  AsyncMemoizer resultsQueryMemoizer;
  List<QuizResult> results;
  List<QuizResult> resultsFiltered;
  String filter = "All";

  //called when state is being created
  @override
  void initState() {
    super.initState();

    //main task is to create the list of questions

    resultsQueryMemoizer = AsyncMemoizer<List<QuizResult>>();
    resultsQuery = resultsQueryMemoizer.runOnce(() {
      db.viewTestResult().then((data) {
        setState(() {
          this.results = data;
          this.resultsFiltered = results;
        });
      });
    });
  }

  void onFloatingActionButtonPress() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test History"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: FutureBuilder(
          future: resultsQuery,
          builder: (context, snapshot) {
            if (results != null) {
              if (results.length == 0) {
                return Center(
                  child: Text(
                    "No data to display",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Filter Test Types",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                  DropdownButton(
                                    value: filter,
                                    items: [
                                      DropdownMenuItem(
                                        child: Text("All"),
                                        value: "All",
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Quick"),
                                        value: TestType.Random.toString(),
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Custom"),
                                        value: TestType.Custom.toString(),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      filter = value;
                                      setState(() {
                                        if (value == "All")
                                          resultsFiltered = results;
                                        else if (value ==
                                            TestType.Random.toString())
                                          resultsFiltered = results
                                              .where((element) =>
                                                  element.testType ==
                                                  TestType.Random.toString())
                                              .toList();
                                        else if (value ==
                                            TestType.Custom.toString())
                                          resultsFiltered = results
                                              .where((element) =>
                                                  element.testType ==
                                                  TestType.Custom.toString())
                                              .toList();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            Text(
                              "Total Attempts",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              "${results.length}",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20),
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.primary,
                              height: 30,
                              thickness: 1,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Total Quick Tests:",
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      Text(
                                        "${results.where((element) => element.testType == TestType.Random.toString()).length}",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  VerticalDivider(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Total Custom Tests:",
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      Text(
                                        "${results.where((element) => element.testType == TestType.Custom.toString()).length}",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: 300,
                                height: 500,
                                padding: EdgeInsets.all(10),
                                child: DChartLine(
                                  data: [
                                    {
                                      'id': 'line',
                                      'data': resultsFiltered.map((e) {
                                        return {
                                          'domain': e.id - 1,
                                          'measure': e.totalCorrect *
                                              100 /
                                              e.totalQuestionCount
                                        };
                                      }).toList()
                                    },
                                  ],
                                  lineColor: (lineData, index, id) =>
                                      Theme.of(context).colorScheme.primary,
                                  includePoints: true,
                                  pointColor: (lineData, index, id) =>
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                )
//                            DChartBar(
//                              data: [
//                                {
//                                  'id': 'Bar',
//                                  'data': resultsFiltered.map((index) {
//                                    return {
//                                      'domain': index.id.toString(),
//                                      'measure': index.totalCorrect *
//                                          100 /
//                                          index.totalQuestionCount
//                                    };
//                                  }).toList(),
//                                },
//                              ],
//                              domainLabelPaddingToAxisLine: 16,
//                              axisLineTick: 2,
//                              axisLinePointTick: 2,
//                              axisLinePointWidth: 10,
//                              axisLineColor:
//                                  Theme.of(context).colorScheme.primary,
//                              measureLabelPaddingToAxisLine: 8,
//                              barColor: (barData, index, id) =>
//                                  Theme.of(context).colorScheme.primary,
//                              showBarValue: true,
//                            ),
                                ),
                          ],
                        ),
                      ),
                    ]);
              }
            } else {
              return Center(
                child: Loading(
                  indicator: BallGridPulseIndicator(),
                  size: 100.0,
                  color: Theme.of(context).primaryColor,
                ),
              );
            }
          },
        ),
      ),
//      floatingActionButton: new Builder(
//        builder: (BuildContext context) {
//          return FloatingActionButton(
//            child: Icon(
//              (questionAnswerState == OptionState.FRESH ||
//                      questionAnswerState == OptionState.SELECTED
//                  ? Icons.check
//                  : Icons.navigate_next),
//            ),
//            onPressed: onFloatingActionButtonPress,
//          );
//        },
//      ),
    );
  }
}
