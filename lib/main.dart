import 'package:flutter/material.dart';
import 'package:cbap_prep_app/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CBAP Prep App',
      initialRoute: homeRoute,
      onGenerateRoute: MyRouter.generateRoute,
      theme: ThemeData(
        // This is the theme of your application.
        primaryColor: Colors.cyan,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
          accentColor: Colors.redAccent,
//          primaryColorDark: Color(0x008ba3),
        ),
      ),
    );
  }
}
