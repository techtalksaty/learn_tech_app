import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '/models/lesson.dart';
import '/models/quiz_question.dart';
import '/models/progress.dart';
import 'data/data_loader.dart';
import 'providers/app_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LessonAdapter());
  Hive.registerAdapter(QuizQuestionAdapter());
  Hive.registerAdapter(ProgressAdapter());
  await Hive.openBox<Lesson>('lessons');
  await Hive.openBox<QuizQuestion>('quizzes');
  await Hive.openBox<Progress>('progress');
  await DataLoader().loadInitialData(); // Load JSON into Hive
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ),
  );
}