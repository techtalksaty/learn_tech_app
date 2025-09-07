import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_provider.dart';
import '../learn/learn_screen.dart';
import '../quiz/quiz_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.fetchProgress();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final progressList = provider.progressList;
          if (progressList.isEmpty) {
            return const Center(
              child: Text(
                'Start learning or take quizzes to track progress!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: progressList.length,
            itemBuilder: (context, index) {
              final progress = progressList[index];
              final totalLessons = provider.getTotalLessons(progress.category);
              return ProgressCard(
                category: progress.category,
                lessonsCompleted: progress.lessonsCompleted,
                totalLessons: totalLessons,
                quizScore: progress.quizScore,
                onLessonTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => LearnScreen(category: progress.category),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                onQuizTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => QuizScreen(category: progress.category),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ProgressCard extends StatefulWidget {
  final String category;
  final int lessonsCompleted;
  final int totalLessons;
  final double quizScore;
  final VoidCallback onLessonTap;
  final VoidCallback onQuizTap;

  const ProgressCard({
    required this.category,
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.quizScore,
    required this.onLessonTap,
    required this.onQuizTap,
    super.key,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonProgress = widget.totalLessons > 0
        ? widget.lessonsCompleted / widget.totalLessons
        : 0.0;
    final quizProgress = widget.quizScore / 100.0;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  categoryIcons[widget.category] ?? Icons.book,
                  size: 24,
                  color: primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => _controller.forward(),
                    onTapUp: (_) {
                      _controller.reverse();
                      widget.onLessonTap();
                    },
                    onTapCancel: () => _controller.reverse(),
                    child: Container(
                      color: Colors.transparent, // Ensures full area is tappable
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lessons',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 6),
                            LinearPercentIndicator(
                              lineHeight: 6.0,
                              percent: lessonProgress,
                              backgroundColor: Colors.grey[300],
                              progressColor: primaryColor,
                              animation: true,
                              animationDuration: 500,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.lessonsCompleted}/${widget.totalLessons}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => _controller.forward(),
                    onTapUp: (_) {
                      _controller.reverse();
                      widget.onQuizTap();
                    },
                    onTapCancel: () => _controller.reverse(),
                    child: Container(
                      color: Colors.transparent, // Ensures full area is tappable
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quiz',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 6),
                            LinearPercentIndicator(
                              lineHeight: 6.0,
                              percent: quizProgress,
                              backgroundColor: Colors.grey[300],
                              progressColor: primaryColor,
                              animation: true,
                              animationDuration: 500,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.quizScore.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}