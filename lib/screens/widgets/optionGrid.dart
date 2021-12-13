import 'package:flutter/material.dart';
import 'package:cbap_prep_app/models/option.dart';

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
            backgroundColor: getBackgroundColor(0, context),
          ),
          onTap: () {
            onOptionRowTap(0);
          },
        ),
        InkWell(
          child: OptionRow(
            option: options[1],
            backgroundColor: getBackgroundColor(1, context),
          ),
          onTap: () {
            onOptionRowTap(1);
          },
        ),
        InkWell(
          child: OptionRow(
            option: options[2],
            backgroundColor: getBackgroundColor(2, context),
          ),
          onTap: () {
            onOptionRowTap(2);
          },
        ),
        InkWell(
          child: OptionRow(
            option: options[3],
            backgroundColor: getBackgroundColor(3, context),
          ),
          onTap: () {
            onOptionRowTap(3);
          },
        ),
      ],
    );
  }

  Color getBackgroundColor(int index, BuildContext context) {
    if (state == OptionState.FRESH) {
      return Colors.transparent;
    } else if (index == selectedIndex) {
      if (state == OptionState.CORRECT) {
        return Colors.green[300];
      } else if (state == OptionState.WRONG) {
        return Colors.red[300];
      } else
        return Theme.of(context).primaryColor;
    } else {
      if (state == OptionState.WRONG && options[index].isAnswer.toLowerCase() == "true") {
        return Colors.green[300];
      }
    }
    return Colors.transparent;
  }
}
