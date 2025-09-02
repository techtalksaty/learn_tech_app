import 'package:hive/hive.dart';
part 'quiz_question.g.dart';

@HiveType(typeId: 1)
class QuizQuestion {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String category;
  @HiveField(2)
  final String question;
  @HiveField(3)
  final List<String> options;
  @HiveField(4)
  final int answer;
  @HiveField(5)
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });
}