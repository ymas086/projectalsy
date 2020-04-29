import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:project_alsy/models/option.dart';
import 'package:project_alsy/models/question.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'dbReference.dart';

class DatabaseHelper {
  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
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
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path);
  }

  // Helper methods

  Future<Question> querySingleQuestionFull() async {
    Database db = await instance.database;
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

  Future<List<Question>> queryQuestionSetFull(int numQuestions) async {
    Database db = await instance.database;
    List<Question> results = new List<Question>();
    List<int> questionIds = generateRandomQuestionIds(numQuestions);
    Question q;

    List<Map> maps = await db.rawQuery(
        "select * from $questionsTable where $columnQuestionId in "
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

    List<Map> optionMaps = await db.rawQuery(
        "select * from $optionsTable where $columnQuestionId in "
            "${mergeQueryIdsInt(questionIds)} order by $columnQuestionId asc");
    print("Options query concluded");

    if (optionMaps.length > 0) {
      for (int i = 0; i < optionMaps.length; i++) {
        results[i ~/ 4].options.add(Option.fromMap(optionMaps[i]));
      }
    }
    return results;
  }

  List<int> generateRandomQuestionIds(int number) {
    Random rand = new Random();
    Set<int> set = new Set<int>(); //sets maintain uniqueness of elements
    while (set.length < number) {
      //continuously generate random numbers, exit once the length = desired number
      set.add(rand.nextInt(1150));
      print(set.last);
    }
    return set.toList();
  }

  String mergeQueryIdsInt(List<int> queryIds) {
    StringBuffer ids = new StringBuffer("(");
    for (int i = 0; i < queryIds.length; i++) {
      ids.write(i < queryIds.length - 1 ? "${queryIds[i]}," : "${queryIds[i]}");
    }
    ids.write(")");

    return ids.toString();
  }
}
