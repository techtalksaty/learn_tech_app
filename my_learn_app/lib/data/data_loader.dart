import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';

class DataLoader {
  Future<void> loadInitialData() async {
    final lessonBox = Hive.box<Lesson>('lessons');
    final quizBox = Hive.box<QuizQuestion>('quizzes');

    // Load lessons
    final lessonFiles = [
      'hardware.json',
      'os.json',
      // Add other category files
    ];

    // for (var file in lessonFiles) {
    //   final jsonString = await DefaultAssetBundle.of(rootBundle).loadString('assets/data/lessons/$file');
    //   final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    //   final categories = jsonData['categories'] as List<dynamic>;
    //   for (var category in categories) {
    //     final lessons = category['learnContent'] as List<dynamic>;
    //     for (var lesson in lessons) {
    //       final lessonObj = Lesson(
    //         id: lesson['id'],
    //         category: category['name'],
    //         question: lesson['question'],
    //         answer: lesson['answer'],
    //       );
    //       await lessonBox.put(lesson['id'], lessonObj);
    //     }
    //   }
    // }

    // Load quizzes
    final quizFiles = [
      'hardware_quiz.json',
      'os_quiz.json',
      // Add other category files
    ];

    // for (var file in quizFiles) {
    //   final jsonString = await DefaultAssetBundle.of(rootBundle).loadString('assets/data/quizzes/$file');
    //   final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    //   final categories = jsonData['categories'] as List<dynamic>;
    //   for (var category in categories) {
    //     final questions = category['questions'] as List<dynamic>;
    //     for (var question in questions) {
    //       final quizObj = QuizQuestion(
    //         id: question['id'],
    //         category: category['name'],
    //         question: question['question'],
    //         options: List<String>.from(question['options']),
    //         answer: question['answer'],
    //         explanation: question['explanation'],
    //       );
    //       await quizBox.put(question['id'], quizObj);
    //     }
    //   }
    // }
  }
}