import 'package:cbap_prep_app/services/dbReference.dart';

class Result {


  //TODO confirm the data structure is appropriate before any further implementation work
  int id;

  DateTime startDateTime;
  DateTime endDateTime;

  String testType;
  String questionRange;
  int totalQuestionCount;
  int totalCorrect;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnResultId: id,
      //no support for native datetime in sqlite, need to convert from int
      columnStartDate: startDateTime.microsecondsSinceEpoch,
      columnEndDate: endDateTime.microsecondsSinceEpoch,
      columnTestType: testType,
      columnQuestionRange: questionRange,
      columnTotalQuestionCount: totalQuestionCount,
      columnTotalCorrect: totalCorrect,
    };
    return map;
  }

  Result();

  Result.fromMap(Map<String, dynamic> map) {
    id = map[columnResultId];
    //no support for native datetime in sqlite, need to convert from int
    startDateTime = DateTime.fromMicrosecondsSinceEpoch(map[columnStartDate]);
    endDateTime = DateTime.fromMicrosecondsSinceEpoch(map[columnEndDate]);
    testType = map[columnTestType];
    questionRange = map[columnQuestionRange];
    totalQuestionCount = map[columnTotalQuestionCount];
    totalCorrect = map[columnTotalCorrect];
  }
}
