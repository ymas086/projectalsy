import 'dart:async';

import 'package:async/async.dart';
import 'package:cbap_prep_app/models/result.dart';
import 'package:cbap_prep_app/services/dbReference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:cbap_prep_app/screens/widgets/questionView.dart';
import 'package:cbap_prep_app/services/dbhelper.dart';
import 'package:cbap_prep_app/models/question.dart';

import 'widgets/optionState.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage(
      {Key key, this.title, this.startIndex, this.numQuestions, this.testType})
      : super(key: key);

  final String title;
  final int startIndex;
  final int numQuestions;
  final TestType testType;

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  static final DatabaseHelper db = DatabaseHelper.instance;
  Future<List<Question>> questionQuery;
  AsyncMemoizer questionQueryMemoizer;
  List<Question> questions;
  OptionState questionAnswerState;
  int currentQuestionIndex;
  int selectedOptionIndex;

  QuizResult currentSessionResult;

  //called when state is being created
  @override
  void initState() {
    super.initState();

    //main task is to create the list of questions
    if (widget.testType == TestType.Random) {
      questionQueryMemoizer = AsyncMemoizer<List<Question>>();
      questionQuery = questionQueryMemoizer.runOnce(() {
        db.queryRandomQuestions(widget.numQuestions).then((data) {
          setState(() {
            this.questions = data;
            currentSessionResult.totalQuestionCount = questions.length;
            currentSessionResult.questionRange =
                questions.map((e) => e.id).join(",");
            print("Question Range: ${currentSessionResult.questionRange}");
          });
        });
      });
    } else if (widget.testType == TestType.Custom) {
      questionQueryMemoizer = AsyncMemoizer<List<Question>>();
      questionQuery = questionQueryMemoizer.runOnce(() {
        db
            .queryQuestionRange(widget.startIndex, widget.numQuestions)
            .then((data) {
          setState(() {
            this.questions = data;
            currentSessionResult.totalQuestionCount = questions.length;

            currentSessionResult.questionRange =
                questions.map((e) => e.id).join(",");
            print("Question Range: ${currentSessionResult.questionRange}");
          });
        });
      });
    }
    questionAnswerState = OptionState.FRESH;
    currentQuestionIndex = 0;
    selectedOptionIndex = 0;

    currentSessionResult = new QuizResult();
    currentSessionResult.totalCorrect = 0;
    currentSessionResult.startDateTime = DateTime.now();
    currentSessionResult.testType = widget.testType.toString();
  }

  void updateSelectedOption(int selectedOptionIndex) {
    if (questionAnswerState == OptionState.FRESH ||
        questionAnswerState == OptionState.SELECTED) {
      setState(() {
        //option should only be updated if current state is either fresh or selected
        this.selectedOptionIndex = selectedOptionIndex;
        this.questionAnswerState = OptionState.SELECTED;
      });
    }
  }

  void updateAnswerState() {
    setState(() {
      //check if current selection = correct answer
      if (questions[currentQuestionIndex]
              .options[selectedOptionIndex]
              .isAnswer
              .toLowerCase() ==
          "true") {
        questionAnswerState = OptionState.CORRECT;
        currentSessionResult.totalCorrect++;
//        numCorrect++;
      } else {
        questionAnswerState = OptionState.WRONG;
      }
    });
  }

  void moveToNextQuestion() {
    setState(() {
      //increment current question counter, reset state
      if (currentQuestionIndex < (questions.length - 1)) {
        currentQuestionIndex++;
        questionAnswerState = OptionState.FRESH;
      } else {
        currentSessionResult.endDateTime = DateTime.now();
        Navigator.pushNamed(context, '/results',
            arguments: [currentSessionResult]);
        setState(() {
          questionAnswerState = OptionState.FINISHED;
        });
      }
    });
  }

  void onFloatingActionButtonPress() {
    //works based on the current state of the widget
//    if (currentQuestionIndex == (questions.length - 1)) {
    if (questionAnswerState == OptionState.FINISHED) {
//          for rapidly getting to the next screen
//          if (true) {
      //we are at the end of the current question list, move to next screen

      //confirm that the test is concluded
      currentSessionResult.endDateTime = DateTime.now();

      Navigator.pushNamed(context, '/results',
          arguments: [currentSessionResult]);
    } else {
      //we are still within the test, determine action based on current state

      if (questionAnswerState == OptionState.FRESH) {
        //nothing selected, return an error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please select an answer")));
      } else if (questionAnswerState == OptionState.SELECTED) {
        //something has been selected. determine if correct or wrong
        updateAnswerState();
      } else if (questionAnswerState == OptionState.CORRECT ||
          questionAnswerState == OptionState.WRONG) {
        //question has already been answered, transition to next question
        moveToNextQuestion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: FutureBuilder(
          future: questionQuery,
          builder: (context, snapshot) {
            if (questions != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RoundedProgressBar(
                    childLeft: Icon(
                      Icons.assessment,
                      color: Colors.cyan[100],
                      size: 25,
                    ),
                    childRight: Text(
                      '${currentQuestionIndex + 1} of ${questions.length}',
                    ),
                    paddingChildLeft: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    paddingChildRight: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    percent:
                        ((currentQuestionIndex + 1) * 100 / questions.length),
                    borderRadius: BorderRadius.circular(30),
                    style: RoundedProgressBarStyle(
                      borderWidth: 2,
                      widthShadow: 10,
                    ),
                    height: 30,
                  ),
//                  Expanded(
//                    child:
                  QuestionView(
                    question: questions[currentQuestionIndex],
                    state: questionAnswerState,
                    selectedIndex: selectedOptionIndex,
                    onOptionRowTap: (index) {
                      //update state with the value from index
                      updateSelectedOption(index);
                    },
                  ),
//                  ),
                ],
              );
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
      floatingActionButton: new Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            child: Icon(
              (questionAnswerState == OptionState.FRESH ||
                      questionAnswerState == OptionState.SELECTED
                  ? Icons.check
                  : Icons.navigate_next),
            ),
            onPressed: onFloatingActionButtonPress,
          );
        },
      ),
    );
  }
}
