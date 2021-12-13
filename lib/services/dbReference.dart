//TODO these first 2 will likely need to be somewhat dynamic and read from Sharedpreference instead.

import 'package:shared_preferences/shared_preferences.dart';

//SharedPreferences sharedPref = SharedPreferences.getInstance();
String questionBank = "CBAP";
String databaseName = "cbap4.sqlite";
int numQuestionsInBank = 500;
List<String> questionBanksList = ["CBAP", "CISA"];

//CREATE TABLE "questions" ( "questionId" INTEGER, "questionText" TEXT, "explanation" TEXT, "questionNumber" INTEGER, "optionIsAnswer" INTEGER, "option1" INTEGER, "option2" INTEGER, "option3" INTEGER, "option4" INTEGER )
const questionsTable = "questions";
const String columnQuestionId = "questionId";
const String columnText = "questionText";
const String columnExplanation = "explanation";
const String columnNumber = "questionNumber";
const String columnOptionIsAnswer = "optionIsAnswer";
const String columnOption1 = "option1";
const String columnOption2 = "option2";
const String columnOption3 = "option3";
const String columnOption4 = "option4";



//﻿CREATE TABLE "options" ( "optionId" INTEGER, "questionId" INTEGER, "sequence" INTEGER, "optionLabel" TEXT, "optionText" TEXT, "isAnswer" TEXT )
const optionsTable = "options";
const String columnOptionId = "optionId";
const String columnSequence = "sequence";
const String columnLabel = "optionLabel";
const String columnOptionText = "optionText";
const String columnIsAnswer = "isAnswer";

//CREATE TABLE "images" ("imageId" INTEGER, "questionId" INTEGER, "sequence" INTEGER, "imageTitle" TEXT, "imageRaw" TEXT)
const imagesTable = "images";
const String columnImageId = "imageId";
const String columnImageTitle = "imageTitle";
const String columnImageRaw = "imageRaw";


const resultsTable = "results";
const String columnResultId = "resultId";
const String columnStartDate = "startDate";
const String columnEndDate = "endDate";
const String columnTestType = "testType";
const String columnQuestionRange = "questionRange";
const String columnTotalQuestionCount = "totalQuestionCount";
const String columnTotalCorrect = "totalCorrect";

enum TestType {Random, Custom}