import 'package:flutter/material.dart';
import 'package:project_alsy/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CISA Prep App',
      initialRoute: homeRoute,
      onGenerateRoute: Router.generateRoute,
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.purple,
        accentColor: Colors.lightGreen,

      ),
    );
  }
}