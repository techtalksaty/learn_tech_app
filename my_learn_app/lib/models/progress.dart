import 'package:hive/hive.dart';
part 'progress.g.dart';

@HiveType(typeId: 2)
class Progress {
  @HiveField(0)
  final String category;
  @HiveField(1)
  final int lessonsCompleted;
  @HiveField(2)
  final double quizScore;

  Progress({
    required this.category,
    this.lessonsCompleted = 0,
    this.quizScore = 0.0,
  });
}