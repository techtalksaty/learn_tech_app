import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';

class DataLoader {
  Future<void> loadInitialData() async {
    final lessonBox = Hive.box<Lesson>('lessons');
    final quizBox = Hive.box<QuizQuestion>('quizzes');

    // Load lessons
    final lessonJson = await rootBundle.loadString('assets/data/lessons.json');
    final lessonData = jsonDecode(lessonJson) as Map<String, dynamic>;
    final lessonCategories = lessonData['categories'] as List<dynamic>;
    for (var category in lessonCategories) {
      final lessons = category['learnContent'] as List<dynamic>;
      for (var lesson in lessons) {
        final lessonObj = Lesson(
          id: lesson['id'],
          category: category['name'],
          question: lesson['question'],
          answer: lesson['answer'],
        );
        await lessonBox.put(lesson['id'], lessonObj);
      }
    }

    // Load quizzes
    final quizJson = await rootBundle.loadString('assets/data/quizzes.json');
    final quizData = jsonDecode(quizJson) as Map<String, dynamic>;
    final quizCategories = quizData['categories'] as List<dynamic>;
    for (var category in quizCategories) {
      final questions = category['questions'] as List<dynamic>;
      for (var question in questions) {
        final quizObj = QuizQuestion(
          id: question['id'],
          category: category['name'],
          question: question['question'],
          options: List<String>.from(question['options']),
          answer: question['answer'],
          explanation: question['explanation'],
        );
        await quizBox.put(question['id'], quizObj);
      }
    }
  }
}