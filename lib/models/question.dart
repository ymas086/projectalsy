import 'package:cbap_prep_app/services/dbReference.dart';

import 'option.dart';
import 'image.dart';

class Question {
  int id;

  String text;
  String explanation;

  int number;
  int optionIsAnswer;

  int optionId1;
  int optionId2;
  int optionId3;
  int optionId4;
  List<Option> options;
  List<Image> images;

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
    options = List<Option>.empty(growable: true);
    images = List<Image>.empty(growable: true);
  }
}
