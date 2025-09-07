import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../screens/learn/learn_category_screen.dart';
import '../screens/quiz/quiz_category_screen.dart' as quiz;
import '../screens/progress/progress_screen.dart' as progress;
import '../providers/app_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const LearnCategoryScreen(),
    quiz.QuizCategoryScreen(),
    progress.ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Basics'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.blueGrey[50], // Unified blue-grey background
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        provider.fetchProgress();
        final progressList = provider.progressList;
        int totalLessonsCompleted = progressList.fold(0, (sum, progress) => sum + progress.lessonsCompleted);
        int totalLessons = progressList.fold(0, (sum, progress) => sum + provider.getTotalLessons(progress.category));
        double lessonProgress = totalLessons > 0 ? totalLessonsCompleted / totalLessons : 0.0;
        double averageQuizScore = progressList.isNotEmpty
            ? progressList.fold(0.0, (sum, progress) => sum + progress.quizScore) / progressList.length
            : 0.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tech Basics',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Learn Computer Fundamentals Anytime Anywhere',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[100], // Light blue background
                                border: Border.all(color: Colors.blue, width: 2), // Blue border
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lessons',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[800], // Dark blue label
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  LinearPercentIndicator(
                                    lineHeight: 6.0,
                                    percent: lessonProgress,
                                    backgroundColor: Colors.grey[300],
                                    progressColor: Colors.blue[600], // Blue progress bar
                                    animation: true,
                                    animationDuration: 500,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$totalLessonsCompleted/$totalLessons',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[600], // Blue progress text
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.indigo[100], // Light indigo background
                                border: Border.all(color: Colors.indigo, width: 2), // Indigo border
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quiz',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.indigo[800], // Dark indigo label
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  LinearPercentIndicator(
                                    lineHeight: 6.0,
                                    percent: averageQuizScore / 100.0,
                                    backgroundColor: Colors.grey[300],
                                    progressColor: Colors.indigo[600], // Indigo progress bar
                                    animation: true,
                                    animationDuration: 500,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${averageQuizScore.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.indigo[600], // Indigo progress text
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.findAncestorStateOfType<_HomeScreenState>()?._onItemTapped(3);
                          },
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600], // Blue for Lessons
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.findAncestorStateOfType<_HomeScreenState>()?._onItemTapped(1);
                },
                child: const Text('Continue Learning'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[600], // Indigo for Quiz
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.findAncestorStateOfType<_HomeScreenState>()?._onItemTapped(2);
                },
                child: const Text('Start Quiz'),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                'Powered By - Satyarth Programming Hub',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}