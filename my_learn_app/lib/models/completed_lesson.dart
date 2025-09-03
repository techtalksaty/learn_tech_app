import 'package:hive/hive.dart';
part 'completed_lesson.g.dart';

@HiveType(typeId: 3)
class CompletedLesson {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final List<String> lessonIds;

  CompletedLesson({
    required this.category,
    this.lessonIds = const [],
  });
}