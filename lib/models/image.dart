import 'package:cbap_prep_app/services/dbReference.dart';

class Image {
  int id;
  int questionId;
  int sequence;

  String title;
  String rawImage;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnImageId: id,
      columnQuestionId: questionId,
      columnSequence: sequence,
      columnImageTitle: title,
      columnImageRaw: rawImage
    };
    return map;
  }

  Image();
//  Image.forRow({this.label, this.text, this.isAnswer});

  Image.fromMap(Map<String, dynamic> map) {
    id = map[columnImageId];
    questionId = map[columnQuestionId];
    sequence = map[columnSequence];
    title = map[columnImageTitle];
    rawImage = map[columnImageRaw];
  }
}

