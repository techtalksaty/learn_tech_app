import 'package:hive/hive.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/progress.dart';
import '../models/completed_lesson.dart';

class LocalRepository {
  final Box<Lesson> _lessonBox = Hive.box<Lesson>('lessons');
  final Box<QuizQuestion> _quizBox = Hive.box<QuizQuestion>('quizzes');
  final Box<Progress> _progressBox = Hive.box<Progress>('progress');
  final Box<CompletedLesson> _completedLessonBox = Hive.box<CompletedLesson>('completed_lessons');

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
      // Create a new list to ensure immutability is handled
      final updatedLessonIds = List<String>.from(completedLesson.lessonIds)..add(lessonId);
      final updatedCompletedLesson = CompletedLesson(
        category: category,
        lessonIds: updatedLessonIds,
      );
      await _completedLessonBox.put(category, updatedCompletedLesson);
      print('Saved completed lesson: $lessonId for $category'); // Debug

      final progress = _progressBox.get(category) ??
          Progress(category: category);
      final updatedProgress = Progress(
        category: category,
        lessonsCompleted: updatedLessonIds.length,
        quizScore: progress.quizScore,
      );
      await _progressBox.put(category, updatedProgress);
      print('Updated progress for $category: ${updatedLessonIds.length} lessons completed'); // Debug
    }
  }
}