import 'package:flutter/material.dart';
import 'package:project_alsy/models/option.dart';

class OptionRow extends StatelessWidget {
  OptionRow({Key key,
    @required this.option,
    @required this.backgroundColor});

  final Option option;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: this.backgroundColor,
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.purple[900],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey[100],
                      fontFamily: "Plaster"),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                option.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
