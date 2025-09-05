import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_provider.dart';

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

  const ProgressCard({
    required this.category,
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.quizScore,
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

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        // Optional: Navigate to LearnScreen or QuizScreen
        // Navigator.push(context, MaterialPageRoute(builder: (context) => LearnScreen(category: widget.category)));
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
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
                    const SizedBox(width: 12),
                    Expanded(
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}