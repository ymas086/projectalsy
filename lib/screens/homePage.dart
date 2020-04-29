import 'package:flutter/material.dart';
import 'package:project_alsy/routes.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Quick Start'),
              onPressed: () {
                Navigator.pushNamed(context, questionsRoute,
                    arguments: ['Question Page', 5]);
              },
            ),
            RaisedButton(
              child: Text('Custom Start'),
            onPressed: () {
//                      Navigator.pushNamed(context, "/questions", arguments: []);
            },
            ),
          ],
        ),
      ),
    );
  }
}
