import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:cbap_prep_app/models/question.dart';

import 'imageViewer.dart';

class ImageGrid extends StatelessWidget {
  ImageGrid({Key key, @required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Accordion(
      maxOpenSections: 1,
      paddingListBottom: 0,
      header: Text("Images Segment"),
      children: question.images.map<AccordionSection>((index) {
        counter += 1;

        return AccordionSection(
          header: Text("Image $counter"),
          content: ImageViewer(image: Image.memory(base64.decode(index.rawImage.substring(22)))),
        );
      }).toList(),
    );
  }
}
