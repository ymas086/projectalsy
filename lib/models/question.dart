import 'package:project_alsy/services/dbReference.dart';

import 'option.dart';

class Question {
  int id;
//  String id;
  String text;
  String explanation;
//  String number;
  int number;
  int optionIsAnswer;
//  String optionIsAnswer;
  int optionId1;
//  String optionId1;
  int optionId2;
//  String optionId2;
  int optionId3;
//  String optionId3;
  int optionId4;
//  String optionId4;
  List<Option> options;

  Question();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnQuestionId: id,
      columnText: text,
      columnExplanation: explanation,
      columnNumber: number,
      columnOptionIsAnswer: optionIsAnswer,
    };
    return map;
  }

  Question.fromMap(Map<String, dynamic> map) {
    id = map[columnQuestionId];
    text = map[columnText];
    explanation = map[columnExplanation];
    number = map[columnNumber];
    optionIsAnswer = map[columnOptionIsAnswer];
    optionId1 = map[columnOption1];
    optionId2 = map[columnOption2];
    optionId3 = map[columnOption3];
    optionId4 = map[columnOption4];
    options = new List<Option>();
  }

//  List<String> getOptionIds(){
//    return [optionId1, optionId2, optionId3, optionId4];
//  }
}
