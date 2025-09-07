import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/category_card.dart';
import './quiz_screen.dart';

class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.blueGrey[50], // Unified blue-grey background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: CategoryCard(
                category: category,
                borderColor: Colors.indigo, // Indigo border
                cardColor: Colors.indigo[100], // Light indigo background
                textColor: Colors.indigo[800], // Dark indigo text/icon
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          QuizScreen(category: category),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}