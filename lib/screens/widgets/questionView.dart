import 'package:flutter/material.dart';
import 'package:cbap_prep_app/models/question.dart';

import 'imageGrid.dart';
import 'optionGrid.dart';
import 'optionState.dart';

class QuestionView extends StatelessWidget {
  QuestionView({Key key,
    this.question,
    this.state = OptionState.FRESH,
    this.selectedIndex = -1,
    this.onOptionRowTap});

  final Question question;
  final OptionState state;
  final int selectedIndex;
  final void Function(int) onOptionRowTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(15),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              question.text,
              textAlign: TextAlign.justify,
            ),
          ),
          Visibility(
            visible: question.images.length != 0 ? true : false,
            child: ImageGrid(question: this.question),
          ),
          OptionGrid(
            options: question.options,
            selectedIndex: selectedIndex,
            state: state,
            onOptionRowTap: onOptionRowTap,
          ),
          Visibility(
            visible:
            state == OptionState.CORRECT || state == OptionState.WRONG
                ? true
                : false,
//              maintainSize: true,
//              maintainAnimation: true,
//              maintainState: true,
            child: Container(
              decoration: new BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Explanation:",
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    question.explanation,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
