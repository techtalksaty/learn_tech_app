import 'package:hive/hive.dart';
part 'lesson.g.dart';

@HiveType(typeId: 0)
class Lesson {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String category;
  @HiveField(2)
  final String question;
  @HiveField(3)
  final String answer;

  Lesson({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });
}