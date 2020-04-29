import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:project_alsy/screens/widgets/questionView.dart';
import 'package:project_alsy/services/dbhelper.dart';
import 'package:project_alsy/models/question.dart';

import 'widgets/optionState.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key, this.title, this.numQuestions}) : super(key: key);

  final String title;
  final int numQuestions;

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
  int numCorrect;

  //called when state is being created
  @override
  void initState() {
    super.initState();

    //main task is to create the list of questions
    questionQueryMemoizer = AsyncMemoizer<List<Question>>();
    questionQuery = questionQueryMemoizer.runOnce(() {
      db.queryQuestionSetFull(widget.numQuestions).then((data) {
        setState(() {
          this.questions = data;
        });
      });
    });
    questionAnswerState = OptionState.FRESH;
    currentQuestionIndex = 0;
    selectedOptionIndex = 0;
    numCorrect = 0;
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
              .isAnswer ==
          "true") {
        questionAnswerState = OptionState.CORRECT;
        numCorrect++;
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
        Navigator.pushNamed(context, '/results',
            arguments: [numCorrect, questions.length]);
        setState(() {
          questionAnswerState = OptionState.FINISHED;
        });
//        Scaffold.of(context).showSnackBar(SnackBar(
//          content: Text('Last question reached, unable to proceed'),
//        ));
      }
    });
  }

  void onFloatingActionButtonPress() {
    //DEBUG
//          print("current score = $numCorrect");
    print("current Question: $currentQuestionIndex");
    print("question count: ${questions.length}");
    print("percentage: ${currentQuestionIndex / questions.length}");

    //works based on the current state of the widget
//    if (currentQuestionIndex == (questions.length - 1)) {
    if (questionAnswerState == OptionState.FINISHED) {
//          for rapidly getting to the next screen
//          if (true) {
      //we are at the end of the current question list, move to next screen

      //confirm that the test is concluded
      Navigator.pushNamed(context, '/results',
          arguments: [numCorrect, questions.length]);
    } else {
      //we are still within the test, determine action based on current state
      if (questionAnswerState == OptionState.FRESH) {
        //nothing selected, return an error
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please select an answer"),
        ));
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

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
                      color: Colors.purple[100],
                      size: 25,
                    ),
                    childRight: Text(
                      '${currentQuestionIndex + 1} of ${questions.length}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    paddingChildLeft: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    paddingChildRight: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    percent:
                        ((currentQuestionIndex + 1) * 100 / questions.length),
                    borderRadius: BorderRadius.circular(30),
                    style: RoundedProgressBarStyle(
                        backgroundProgress: Colors.lightGreen[300],
                        colorProgress: Colors.purple[500],
                        borderWidth: 2,
                        widthShadow: 10,
                        colorBackgroundIcon: Colors.red[500],
                        colorProgressDark: Colors.purple[700],
                        colorBorder: Colors.grey[500]),
                    height: 30,
                  ),
                  QuestionView(
                    question: questions[currentQuestionIndex],
                    state: questionAnswerState,
                    selectedIndex: selectedOptionIndex,
                    onOptionRowTap: (index) {
                      //update state with the value from index
                      updateSelectedOption(index);
                    },
                  ),
                ],
              );
            } else {
              return Center(
                child: Loading(
                  indicator: BallGridPulseIndicator(),
                  size: 100.0,
                  color: Colors.purple[500],
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
