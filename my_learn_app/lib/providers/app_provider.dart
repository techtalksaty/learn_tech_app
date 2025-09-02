import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../repositories/local_repository.dart';

class AppProvider with ChangeNotifier {
  final LocalRepository _repository = LocalRepository();

  List<Lesson> _lessons = [];

  List<Lesson> get lessons => _lessons;

  void fetchLessons(String category) {
    _lessons = _repository.getLessonsByCategory(category);
    notifyListeners();
  }
}