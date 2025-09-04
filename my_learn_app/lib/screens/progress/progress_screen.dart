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
            padding: const EdgeInsets.all(12.0), // Reduced padding
            itemCount: progressList.length,
            itemBuilder: (context, index) {
              final progress = progressList[index];
              final totalLessons = provider.getTotalLessons(progress.category);
              final lessonProgress = totalLessons > 0
                  ? progress.lessonsCompleted / totalLessons
                  : 0.0;
              final quizProgress = progress.quizScore / 100.0;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 6.0), // Reduced margin
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Reduced padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.category,
                        style: const TextStyle(
                          fontSize: 18, // Slightly smaller font
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12), // Reduced spacing
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.book, size: 16, color: primaryColor), // Smaller icon
                                    const SizedBox(width: 6), // Reduced spacing
                                    Flexible(
                                      child: Text(
                                        'Lessons',
                                        style: TextStyle(
                                          fontSize: 14, // Smaller font
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6), // Reduced spacing
                                LinearPercentIndicator(
                                  lineHeight: 6.0, // Thinner bar
                                  percent: lessonProgress,
                                  backgroundColor: Colors.grey[300],
                                  progressColor: primaryColor,
                                  animation: true,
                                  animationDuration: 500,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${progress.lessonsCompleted}/$totalLessons',
                                  style: TextStyle(
                                    fontSize: 12, // Smaller font
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12), // Reduced spacing
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.quiz, size: 16, color: primaryColor), // Smaller icon
                                    const SizedBox(width: 6), // Reduced spacing
                                    Flexible(
                                      child: Text(
                                        'Quiz',
                                        style: TextStyle(
                                          fontSize: 14, // Smaller font
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6), // Reduced spacing
                                LinearPercentIndicator(
                                  lineHeight: 6.0, // Thinner bar
                                  percent: quizProgress,
                                  backgroundColor: Colors.grey[300],
                                  progressColor: primaryColor,
                                  animation: true,
                                  animationDuration: 500,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${progress.quizScore.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 12, // Smaller font
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
              );
            },
          );
        },
      ),
    );
  }
}