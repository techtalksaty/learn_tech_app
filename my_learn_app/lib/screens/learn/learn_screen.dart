import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class LearnScreen extends StatelessWidget {
  final String category;

  const LearnScreen({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.fetchLessons(category);

    return Scaffold(
      appBar: AppBar(
        title: Text('Learn: $category'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final lessons = provider.lessons;
          if (lessons.isEmpty) {
            return const Center(child: Text('No lessons available'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              final isCompleted = provider.isLessonCompleted(category, lesson.id);
              return Card(
                child: ExpansionTile(
                  title: Text(
                    lesson.question,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarkdownBody(data: lesson.answer),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: isCompleted
                                ? null
                                : () {
                                    provider.markLessonCompleted(category, lesson.id);
                                  },
                            child: Text(
                              isCompleted ? 'Completed' : 'Mark as Completed',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}