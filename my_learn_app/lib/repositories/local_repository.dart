import 'package:hive/hive.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/progress.dart';
import '../models/completed_lesson.dart';
import '../models/quiz_answer.dart';

class LocalRepository {
  final Box<Lesson> _lessonBox = Hive.box<Lesson>('lessons');
  final Box<QuizQuestion> _quizBox = Hive.box<QuizQuestion>('quizzes');
  final Box<Progress> _progressBox = Hive.box<Progress>('progress');
  final Box<CompletedLesson> _completedLessonBox = Hive.box<CompletedLesson>('completed_lessons');
  final Box<QuizAnswer> _quizAnswerBox = Hive.box<QuizAnswer>('quiz_answers');

  List<Lesson> getLessonsByCategory(String category) {
    return _lessonBox.values
        .where((lesson) => lesson.category == category)
        .toList();
  }

  List<QuizQuestion> getQuizQuestionsByCategory(String category) {
    return _quizBox.values
        .where((question) => question.category == category)
        .toList();
  }

  Progress? getProgressByCategory(String category) {
    final progressList = _progressBox.values
        .where((progress) => progress.category == category)
        .toList();
    return progressList.isNotEmpty ? progressList.first : null;
  }

  Future<void> updateProgress(Progress progress) async {
    await _progressBox.put(progress.category, progress);
  }

  List<String> getCompletedLessonIds(String category) {
    final completedLesson = _completedLessonBox.get(category);
    return completedLesson?.lessonIds ?? [];
  }

  Future<void> markLessonCompleted(String category, String lessonId) async {
    final completedLesson = _completedLessonBox.get(category) ??
        CompletedLesson(category: category);
    if (!completedLesson.lessonIds.contains(lessonId)) {
      final updatedLessonIds = List<String>.from(completedLesson.lessonIds)..add(lessonId);
      final updatedCompletedLesson = CompletedLesson(
        category: category,
        lessonIds: updatedLessonIds,
      );
      await _completedLessonBox.put(category, updatedCompletedLesson);

      final progress = _progressBox.get(category) ??
          Progress(category: category);
      final updatedProgress = Progress(
        category: category,
        lessonsCompleted: updatedLessonIds.length,
        quizScore: progress.quizScore,
      );
      await _progressBox.put(category, updatedProgress);
    }
  }

  Map<String, int> getQuizAnswers(String category) {
    final quizAnswer = _quizAnswerBox.get(category);
    return quizAnswer?.answeredQuestions ?? {};
  }

  Future<void> updateQuizAnswer(String category, String questionId, int selectedOption) async {
    final quizAnswer = _quizAnswerBox.get(category) ??
        QuizAnswer(category: category);
    final updatedAnswers = Map<String, int>.from(quizAnswer.answeredQuestions)
      ..[questionId] = selectedOption;
    final updatedQuizAnswer = QuizAnswer(
      category: category,
      answeredQuestions: updatedAnswers,
    );
    await _quizAnswerBox.put(category, updatedQuizAnswer);

    // Update progress with current score
    final questions = getQuizQuestionsByCategory(category);
    final answers = getQuizAnswers(category);
    int correctAnswers = 0;
    for (var question in questions) {
      final selectedOption = answers[question.id];
      if (selectedOption != null && selectedOption == question.answer) {
        correctAnswers++;
      }
    }
    final quizScore = questions.isNotEmpty ? (correctAnswers / questions.length) * 100 : 0.0;
    final progress = _progressBox.get(category) ?? Progress(category: category);
    final updatedProgress = Progress(
      category: category,
      lessonsCompleted: progress.lessonsCompleted,
      quizScore: quizScore,
    );
    await _progressBox.put(category, updatedProgress);
  }

  Future<void> resetQuizAnswers(String category) async {
    await _quizAnswerBox.delete(category);
    final progress = _progressBox.get(category) ?? Progress(category: category);
    final updatedProgress = Progress(
      category: category,
      lessonsCompleted: progress.lessonsCompleted,
      quizScore: 0.0,
    );
    await _progressBox.put(category, updatedProgress); 
  }
}