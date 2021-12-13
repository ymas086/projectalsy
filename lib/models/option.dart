import 'package:cbap_prep_app/services/dbReference.dart';

class Option {
  int id;
//  String id;
  int questionId;
//  String questionId;
  int sequence;
//  String sequence;
  String label;
  String text;
  String isAnswer;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnOptionId: id,
      columnQuestionId: questionId
    };
    return map;
  }

  Option();
  Option.forRow({this.label, this.text, this.isAnswer});

  Option.fromMap(Map<String, dynamic> map) {
    id = map[columnOptionId];
    questionId = map[columnQuestionId];
    sequence = map[columnSequence];
    label = map[columnLabel];
    text = map[columnOptionText];
    isAnswer = map[columnIsAnswer];
  }
}