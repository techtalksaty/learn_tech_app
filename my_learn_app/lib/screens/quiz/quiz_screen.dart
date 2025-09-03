import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
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
    // Initialize state for the first question
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedOption = provider.quizAnswers(widget.category)[provider.quizQuestions[_currentQuestionIndex].id];
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
        _selectedOption = provider.quizAnswers(widget.category)[provider.quizQuestions[_currentQuestionIndex].id];
        _isSubmitted = _selectedOption != null;
        print('Navigated to question ${_currentQuestionIndex + 1}, selected: $_selectedOption, submitted: $_isSubmitted');
      });
    } else {
      provider.saveQuizProgress(widget.category);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Completed'),
          content: Text('Your score: ${provider.quizScore.toStringAsFixed(1)}%'),
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
    print('Reset quiz for ${widget.category}');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final questions = provider.quizQuestions;

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz: ${widget.category}')),
        body: const Center(child: Text('No quiz questions available')),
      );
    }

    final question = questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.category}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _resetQuiz(provider),
            tooltip: 'Reset Quiz',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              question.question,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return RadioListTile<int>(
                title: Text(option),
                value: index,
                groupValue: _selectedOption,
                onChanged: _isSubmitted
                    ? null
                    : (value) => setState(() {
                          _selectedOption = value;
                          print('Selected option $value for question ${question.id}');
                        }),
              );
            }).toList(),
            if (_isSubmitted) ...[
              const SizedBox(height: 16),
              MarkdownBody(data: question.explanation),
              const SizedBox(height: 16),
              Text(
                _selectedOption == question.answer ? 'Correct!' : 'Incorrect',
                style: TextStyle(
                  color: _selectedOption == question.answer ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _isSubmitted
                  ? () => _nextQuestion(provider)
                  : () => _submitAnswer(provider, question),
              child: Text(_isSubmitted ? 'Next' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}