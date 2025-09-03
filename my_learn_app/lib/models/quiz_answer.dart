import 'package:hive/hive.dart';
part 'quiz_answer.g.dart';

@HiveType(typeId: 4)
class QuizAnswer {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final Map<String, int> answeredQuestions; // questionId: selectedOption

  QuizAnswer({
    required this.category,
    this.answeredQuestions = const {},
  });
}