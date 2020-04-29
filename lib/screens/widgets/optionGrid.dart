import 'package:flutter/material.dart';
import 'package:project_alsy/models/option.dart';

import 'optionRow.dart';
import 'optionState.dart';

class OptionGrid extends StatelessWidget {
  OptionGrid({
    Key key,
    @required this.options,
    this.selectedIndex,
    this.state = OptionState.FRESH,
    this.onOptionRowTap,
  });

  final List<Option> options;
  final int selectedIndex;
  final OptionState state;
  final void Function(int) onOptionRowTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: OptionRow(
            option: options[0],
            backgroundColor: getBackgroundColor(0),
          ),
          onTap: () {
            onOptionRowTap(0);
          },
        ),
        InkWell(
          child: OptionRow(
            option: options[1],
            backgroundColor: getBackgroundColor(1),
          ),
          onTap: () {
            onOptionRowTap(1);
          },
        ),
        InkWell(
          child: OptionRow(
            option: options[2],
            backgroundColor: getBackgroundColor(2),
          ),
          onTap: () {
            onOptionRowTap(2);
          },
        ),
        InkWell(
          child: OptionRow(
            option: options[3],
            backgroundColor: getBackgroundColor(3),
          ),
          onTap: () {
            onOptionRowTap(3);
          },
        ),
      ],
    );
  }

  Color getBackgroundColor(int index) {
    if (state == OptionState.FRESH) {
      return Colors.transparent;
    } else if (index == selectedIndex) {
      if (state == OptionState.CORRECT) {
        return Colors.green[300];
      } else if (state == OptionState.WRONG) {
        return Colors.red[300];
      } else
        return Colors.purple[100];
    } else {
      if (state == OptionState.WRONG && options[index].isAnswer == "true") {
        return Colors.green[300];
      }
    }
  }
}
