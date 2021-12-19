import 'dart:io';
import 'dart:math';

import 'package:cbap_prep_app/models/image.dart';
import 'package:cbap_prep_app/models/questionBank.dart';
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

  static Database _questionDatabase;
  static SharedPreferences _sharedPref;

  String questionBank;
  String databaseName;
  int numQuestionsInBank;

  Future<Database> get questionDatabase async {
    if (_questionDatabase != null) return _questionDatabase;
    // lazily instantiate the db the first time it is accessed
    _questionDatabase = await _initDatabase();
    return _questionDatabase;
  }

  Future<SharedPreferences> get sharedPref async {
    _sharedPref = await SharedPreferences.getInstance();

//    sharedPref.clear();
//    if (sharedPref.getKeys().isEmpty) {
    if (_sharedPref.containsKey("question_bank") == false) {
      //no keys exist, so save CBAP question bank as default
      _sharedPref.setString("question_bank", "CBAP 2");
      _sharedPref.setString("database_name", "cbap4.sqlite");
      _sharedPref.setInt("question_count", 500);
      _sharedPref.setStringList("question_bank_list",
          questionBanksList2.map((index) => index.identifier).toList());

      print(
          "List of Questions in Shared Pref: ${_sharedPref.getStringList("question_bank_list")}");
    } else {
      questionBank = _sharedPref.getString("question_bank");
      databaseName = _sharedPref.getString("database_name");
      numQuestionsInBank = _sharedPref.getInt("question_count");
    }

    return _sharedPref;
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

      //Populate options array
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

      //Populate images array
      try {
        List<Map> mapsImages = await db.query(
          imagesTable,
          columns: [
            columnImageId,
            columnQuestionId,
            columnSequence,
            columnImageTitle,
            columnImageRaw
          ],
          where: "$columnQuestionId = ?",
          whereArgs: [q.id],
          limit: 4,
        );

        if (mapsImages.length > 0) {
          for (Map m in mapsImages) {
            q.images.add(Image.fromMap(m));
          }
        }
      } on Exception catch (exception) {
        print("Database does not contain images table");
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

    try {
      List<Map> imageMaps = await db.rawQuery(
          "select * from $imagesTable where $columnQuestionId in "
          "${mergeQueryIdsInt(questionIds)} order by $columnQuestionId asc");
      print("images query concluded");

      if (imageMaps.length > 0) {
        for (int i = 0; i < imageMaps.length; i++) {
          results[questionIds.indexOf(imageMaps[i][columnQuestionId])]
              .images
              .add(Image.fromMap(imageMaps[i]));
        }
      }
    } on Exception catch (e) {
      print("Database does not contain images table");
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

    try {
      List<Map> imageMaps = await db.rawQuery(
          "select * from $imagesTable where $columnQuestionId in "
          "${mergeQueryIdsInt(questionIds)} order by $columnQuestionId asc");
      print("images query concluded");

      if (imageMaps.length > 0) {
        for (int i = 0; i < imageMaps.length; i++) {
          results[questionIds.indexOf(imageMaps[i][columnQuestionId])]
              .images
              .add(Image.fromMap(imageMaps[i]));
        }
      }
    } on Exception catch (e) {
      print("Database does not contain an images table");
    }

    print("Results length:" + results.length.toString());
    return results;
  }

  void saveTestResult(QuizResult result) async {
    Database db = await instance.questionDatabase;
    await db.rawQuery("create table if not exists $resultsTable "
        "($columnResultId INTEGER PRIMARY KEY, $columnStartDate INTEGER, $columnEndDate INTEGER, $columnTestType TEXT,"
        "$columnQuestionRange TEXT, $columnTotalQuestionCount INTEGER, $columnTotalCorrect INTEGER)");

    //create the result set with questions
    await db.insert(resultsTable, result.toMap());

    viewTestResult();
  }

  Future<List<QuizResult>> viewTestResult() async {
    //TODO tailor this to be usable in results history screen
    Database db = await instance.questionDatabase;
    List<QuizResult> results = List<QuizResult>.empty(growable: true);

    try {
      List<Map> resultsMap = await db.rawQuery("select * from $resultsTable "
          "order by $columnResultId asc");

      print("number of results: ${resultsMap.length}");

      if (resultsMap.length > 0) {
        for (Map m in resultsMap) results.add(QuizResult.fromMap(m));
      }
    } on Exception catch (e) {
      print("Database for results does not exist");
    }

    return results;
  }

  void updateSelectedQuestionBank(QuestionBank bank) async {
    print("update question bank called");
    _sharedPref.setString("question_bank", bank.identifier);
    _sharedPref.setString("database_name", bank.dbName);
    _sharedPref.setInt("question_count", bank.numQuestions);

    questionBank = bank.identifier;
    databaseName = bank.dbName;
    numQuestionsInBank = bank.numQuestions;

    _questionDatabase = await _initDatabase();
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
