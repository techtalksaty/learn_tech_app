import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
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
  List<Progress> _progressList = [];
  Map<String, List<String>> _completedLessonIds = {};
  Map<String, Map<String, int>> _quizAnswers = {};

  List<Lesson> get lessons => _lessons;
  List<QuizQuestion> get quizQuestions => _quizQuestions;
  double get quizScore => _totalQuizQuestions > 0 ? (_currentQuizScore / _totalQuizQuestions) * 100 : 0.0;
  List<Progress> get progressList => _progressList;
  Map<String, int> quizAnswers(String category) => _quizAnswers[category] ?? {};

  void fetchLessons(String category) {
    _lessons = _repository.getLessonsByCategory(category);
    _completedLessonIds[category] = _repository.getCompletedLessonIds(category);
    notifyListeners();
  }

  void fetchQuizQuestions(String category) {
    _quizQuestions = _repository.getQuizQuestionsByCategory(category);
    _quizAnswers[category] = _repository.getQuizAnswers(category);
    _totalQuizQuestions = _quizQuestions.length;
    _currentQuizScore = 0;
    for (var question in _quizQuestions) {
      final selectedOption = _quizAnswers[category]?[question.id];
      if (selectedOption != null && selectedOption == question.answer) {
        _currentQuizScore++;
      }
    }
    print('Fetched quiz for $category: $_currentQuizScore/$_totalQuizQuestions');
    notifyListeners();
  }

  Future<void> updateQuizAnswer(String category, String questionId, int selectedOption) async {
    await _repository.updateQuizAnswer(category, questionId, selectedOption);
    _quizAnswers[category] = _repository.getQuizAnswers(category);
    _currentQuizScore = 0;
    for (var question in _quizQuestions) {
      final selectedOption = _quizAnswers[category]?[question.id];
      if (selectedOption != null && selectedOption == question.answer) {
        _currentQuizScore++;
      }
    }
    print('Updated quiz answer for $category, score: $_currentQuizScore/$_totalQuizQuestions');
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
    print('Saved quiz progress for $category: ${quizScore.toStringAsFixed(1)}%');
    fetchProgress();
  }

  void fetchProgress() {
    _progressList = categories
        .map((category) => _repository.getProgressByCategory(category) ??
            Progress(category: category))
        .toList();
    print('Fetched progress: ${_progressList.map((p) => "${p.category}: ${p.quizScore}%").toList()}');
    notifyListeners();
  }

  int getTotalLessons(String category) {
    return _repository.getLessonsByCategory(category).length;
  }

  bool isLessonCompleted(String category, String lessonId) {
    return _completedLessonIds[category]?.contains(lessonId) ?? false;
  }

  Future<void> markLessonCompleted(String category, String lessonId) async {
    await _repository.markLessonCompleted(category, lessonId);
    _completedLessonIds[category] = _repository.getCompletedLessonIds(category);
    print('Provider updated completed lessons for $category: ${_completedLessonIds[category]}');
    fetchProgress();
    notifyListeners();
  }

  Future<void> resetQuiz(String category) async {
    await _repository.resetQuizAnswers(category);
    _quizAnswers[category] = {};
    _currentQuizScore = 0;
    await saveQuizProgress(category); // Update progress to reflect reset
    notifyListeners();
  }
}