import 'package:hive/hive.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/progress.dart';

class LocalRepository {
  final Box<Lesson> _lessonBox = Hive.box<Lesson>('lessons');
  final Box<QuizQuestion> _quizBox = Hive.box<QuizQuestion>('quizzes');
  final Box<Progress> _progressBox = Hive.box<Progress>('progress');

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
}