import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../models/quiz_question.dart';
import '../../providers/app_provider.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({required this.category, super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedOption;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.fetchQuizQuestions(widget.category);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedOption = provider.quizAnswers(
          widget.category,
        )[provider.quizQuestions[_currentQuestionIndex].id];
        _isSubmitted = _selectedOption != null;
      });
    });
  }

  void _submitAnswer(AppProvider provider, QuizQuestion question) {
    if (_selectedOption == null) return;
    setState(() {
      _isSubmitted = true;
      provider.updateQuizAnswer(widget.category, question.id, _selectedOption!);
    });
  }

  void _nextQuestion(AppProvider provider) {
    if (_currentQuestionIndex < provider.quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = provider.quizAnswers(
          widget.category,
        )[provider.quizQuestions[_currentQuestionIndex].id];
        _isSubmitted = _selectedOption != null;
      });
    } else {
      provider.saveQuizProgress(widget.category);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Completed'),
          content: Text(
            'Your score: ${provider.quizScore.toStringAsFixed(1)}%',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _resetQuiz(AppProvider provider) {
    provider.resetQuiz(widget.category);
    setState(() {
      _currentQuestionIndex = 0;
      _selectedOption = null;
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final questions = provider.quizQuestions;

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz: ${widget.category}'),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: const Center(child: Text('No quiz questions available')),
      );
    }

    final question = questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.category}'),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _resetQuiz(provider),
            tooltip: 'Reset Quiz',
          ),
        ],
      ),
      backgroundColor: Colors.orange[50], // Light cream/orange background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.orange, width: 2), // Orange border
            ),
            color: Colors.orange[100], // Light orange tint
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent, // Orange accent for question count
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // White background for options
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[300]!), // Light orange border
                      ),
                      child: RadioListTile<int>(
                        title: Text(option),
                        value: index,
                        groupValue: _selectedOption,
                        activeColor: Colors.orange[600], // Orange radio button
                        onChanged: _isSubmitted
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedOption = value;
                                });
                              },
                      ),
                    );
                  }),
                  if (_isSubmitted) ...[
                    const SizedBox(height: 16),
                    MarkdownBody(data: question.explanation),
                    const SizedBox(height: 16),
                    Text(
                      _selectedOption == question.answer ? 'Correct!' : 'Incorrect',
                      style: TextStyle(
                        color: _selectedOption == question.answer
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isSubmitted
                        ? () => _nextQuestion(provider)
                        : () => _submitAnswer(provider, question),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600], // Orange button
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(_isSubmitted ? 'Next' : 'Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}