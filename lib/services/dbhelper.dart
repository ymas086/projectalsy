import 'dart:io';
import 'dart:math';

import 'package:cbap_prep_app/models/result.dart';
import 'package:path/path.dart';
import 'package:cbap_prep_app/models/option.dart';
import 'package:cbap_prep_app/models/question.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'dbReference.dart';

class DatabaseHelper {
  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the databases
  //TODO refactor this class to factor in writes to questionDB to store results.

  static Database _questionDatabase;
  static Database _controlDatabase;
  static SharedPreferences sharedPref;

  Future<Database> get questionDatabase async {
    //TODO setup the sharedPreferences here...for the first time
//    sharedPref = await SharedPreferences.getInstance();
//
//    if (sharedPref.getKeys().isEmpty) {
//      //no keys exist, so save CBAP question bank as default
//      sharedPref.setString("question_bank", "CBAP");
//      sharedPref.setString("database_name", "cbap2.sqlite");
//      sharedPref.setInt("question_count", 150);
//      sharedPref.setStringList("question_bank_list", questionBanksList);
//    }

    if (_questionDatabase != null) return _questionDatabase;
    // lazily instantiate the db the first time it is accessed
    _questionDatabase = await _initDatabase();
    return _questionDatabase;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);

// Check if the database exists
    bool exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

// open the database
    print("path: $path");
    return await openDatabase(path);
  }

  // Helper methods

  Future<Question> querySingleQuestionFull() async {
    Database db = await instance.questionDatabase;
    Question q;
    List<Map> maps = await db.query(
      questionsTable,
      columns: [
        columnQuestionId,
        columnText,
        columnExplanation,
        columnNumber,
        columnOptionIsAnswer,
        columnOption1,
        columnOption2,
        columnOption3,
        columnOption4
      ],
      limit: 1,
    );
    print("Map length:" + maps.length.toString());
    if (maps.length > 0) {
      q = Question.fromMap(maps[0]);
      //q.options = new List<Option>();
      List<Map> mapsOptions = await db.query(
        optionsTable,
        columns: [
          columnOptionId,
          columnQuestionId,
          columnSequence,
          columnLabel,
          columnOptionText,
          columnIsAnswer,
        ],
        where: "$columnQuestionId = ?",
        whereArgs: [q.id],
        limit: 4,
      );

      if (mapsOptions.length > 0) {
        for (Map m in mapsOptions) {
          q.options.add(Option.fromMap(m));
        }
      }
    }
    return q;
  }

  Future<List<Question>> queryRandomQuestions(int numQuestions) async {
    Database db = await instance.questionDatabase;
    List<Question> results = List<Question>.empty(growable: true);
    List<int> questionIds = generateRandomQuestionIds(numQuestions);
    Question q;

    List<Map> maps = await db
        .rawQuery("select * from $questionsTable where $columnQuestionId in "
            "${mergeQueryIdsInt(questionIds)} order by $columnQuestionId asc");

    //create the result set with questions
    if (maps.length > 0) {
      for (Map m in maps) {
        q = Question.fromMap(m);

        print(m[columnQuestionId]);
        results.add(q);
      }
    }
    print("Questions query concluded");

    List<Map> optionMaps = await db
        .rawQuery("select * from $optionsTable where $columnQuestionId in "
            "${mergeQueryIdsInt(questionIds)} order by $columnQuestionId asc");
    print("Options query concluded");

    if (optionMaps.length > 0) {
      for (int i = 0; i < optionMaps.length; i++) {
        results[i ~/ 4].options.add(Option.fromMap(optionMaps[i]));
      }
    }

    print("Results length:" + results.length.toString());
    return results;
  }

  Future<List<Question>> queryQuestionRange(
      int startIndex, int numQuestions) async {
    Database db = await instance.questionDatabase;
    List<Question> results = List<Question>.empty(growable: true);
    List<int> questionIds =
        new List<int>.generate(numQuestions, (i) => i + startIndex);
    Question q;

    List<Map> maps = await db
        .rawQuery("select * from $questionsTable where $columnQuestionId in "
            "${mergeQueryIdsInt(questionIds)} order by $columnQuestionId asc");

    //create the result set with questions
    if (maps.length > 0) {
      for (Map m in maps) {
        q = Question.fromMap(m);

        print(m[columnQuestionId]);
        results.add(q);
      }
    }
    print("Questions query concluded");

    List<Map> optionMaps = await db
        .rawQuery("select * from $optionsTable where $columnQuestionId in "
            "${mergeQueryIdsInt(questionIds)} order by $columnQuestionId asc");
    print("Options query concluded");

    if (optionMaps.length > 0) {
      for (int i = 0; i < optionMaps.length; i++) {
        results[i ~/ 4].options.add(Option.fromMap(optionMaps[i]));
      }
    }

    print("Results length:" + results.length.toString());
    return results;
  }

  void saveTestResult(Result result) async {
    Database db = await instance.questionDatabase;
    //TODO insert create if not exists query for the results table
    await db.rawQuery("create table if not exists results "
        "(columnResultId int, columnStartDate int, columnEndDate int, columnTestType text,"
        "columnQuestionRange text, columnTotalQuestionCount, int, columnTotalCorrect int)");
//    const String columnResultId = "resultId";
//    const String columnStartDate = "startDate";
//    const String columnEndDate = "endDate";
//    const String columnTestType = "testType";
//    const String columnQuestionRange = "questionRange";
//    const String columnTotalQuestionCount = "totalQuestionCount";
//    const String columnTotalCorrect = "totalCorrect";
    //TODO write the results

//    List<Map> maps = await db
//        .rawQuery("select * from $questionsTable where $columnQuestionId in "
//        "${mergeQueryIdsInt(questionIds)} order by $columnQuestionId asc");

    //create the result set with questions
  }

  void writeDatabasePreferences(String questionBank) {
    switch (questionBank) {
      case "CBAP":
      //do something
      case "CISA":
      //do something else
      default:
    }
  }

  //for generating an array of random numbers capped at the number of questions in the question bank
  List<int> generateRandomQuestionIds(int number) {
    Random rand = new Random();
    Set<int> set = new Set<int>(); //sets maintain uniqueness of elements
    while (set.length < number) {
      //continuously generate random numbers, exit once the length = desired number
      //This number needs to be manually edited because it must be pegged to the total number of questions to be expected in the question bank
      set.add(rand.nextInt(numQuestionsInBank));
      print(set.last);
    }
    return set.toList();
  }

  //For creating a string of indices for the sql query
  String mergeQueryIdsInt(List<int> queryIds) {
    StringBuffer ids = new StringBuffer("(");
    for (int i = 0; i < queryIds.length; i++) {
      ids.write(i < queryIds.length - 1 ? "${queryIds[i]}," : "${queryIds[i]}");
    }
    ids.write(")");

    return ids.toString();
  }
}
