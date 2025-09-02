import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.fetchProgress(); // Load progress data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final progressList = provider.progressList;
          if (progressList.isEmpty) {
            return const Center(child: Text('Start learning to track progress!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: progressList.length,
            itemBuilder: (context, index) {
              final progress = progressList[index];
              final totalLessons = provider.getTotalLessons(progress.category);
              final lessonProgress = totalLessons > 0
                  ? progress.lessonsCompleted / totalLessons
                  : 0.0;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.category,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Lessons Completed'),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: lessonProgress,
                                  backgroundColor: Colors.grey[300],
                                  color: primaryColor,
                                ),
                                Text(
                                  '${progress.lessonsCompleted}/$totalLessons lessons',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          CircularPercentIndicator(
                            radius: 40.0,
                            lineWidth: 8.0,
                            percent: progress.quizScore / 100,
                            center: Text(
                              '${progress.quizScore.toStringAsFixed(1)}%',
                              style: const TextStyle(fontSize: 16),
                            ),
                            progressColor: primaryColor,
                            backgroundColor: Colors.grey[300]!,
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