import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/progress.dart';
import '../repositories/local_repository.dart';

class AppProvider with ChangeNotifier {
  final LocalRepository _repository = LocalRepository();

  List<Lesson> _lessons = [];
  List<QuizQuestion> _quizQuestions = [];
  int _currentQuizScore = 0;
  int _totalQuizQuestions = 0;

  List<Lesson> get lessons => _lessons;
  List<QuizQuestion> get quizQuestions => _quizQuestions;
  double get quizScore => _totalQuizQuestions > 0 ? (_currentQuizScore / _totalQuizQuestions) * 100 : 0.0;

  void fetchLessons(String category) {
    _lessons = _repository.getLessonsByCategory(category);
    notifyListeners();
  }

  void fetchQuizQuestions(String category) {
    _quizQuestions = _repository.getQuizQuestionsByCategory(category);
    _currentQuizScore = 0;
    _totalQuizQuestions = _quizQuestions.length;
    notifyListeners();
  }

  void updateQuizScore(bool isCorrect) {
    if (isCorrect) {
      _currentQuizScore++;
    }
    notifyListeners();
  }

  Future<void> saveQuizProgress(String category) async {
    final progress = _repository.getProgressByCategory(category) ??
        Progress(category: category);
    final updatedProgress = Progress(
      category: category,
      lessonsCompleted: progress.lessonsCompleted,
      quizScore: quizScore,
    );
    await _repository.updateProgress(updatedProgress);
    notifyListeners();
  }
}