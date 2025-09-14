import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_provider.dart';

class LearnScreen extends StatefulWidget {
  final String category;

  const LearnScreen({required this.category, super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final Map<String, bool> _localCompletionStatus = {};

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.fetchLessons(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn: ${widget.category}'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.blueGrey[50], // Unified blue-grey background
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
              // Use local state, fallback to provider
              final isCompleted = _localCompletionStatus[lesson.id] ??
                  provider.isLessonCompleted(widget.category, lesson.id);
              return AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.blue, width: 2), // Blue border
                  ),
                  color: Colors.blue[100], // Light blue background
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    title: Text(
                      lesson.question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.grey : Colors.blue[800], // Dark blue for uncompleted
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
                                      setState(() {
                                        _localCompletionStatus[lesson.id] = true; // Optimistic update
                                      });
                                      provider.markLessonCompleted(widget.category, lesson.id);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600], // Blue button
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                isCompleted ? 'Completed' : 'Mark as Completed',
                              ),
                            ),
                          ],
                        ),
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