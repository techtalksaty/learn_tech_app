import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../screens/learn/learn_screen.dart';
import '../../widgets/category_card.dart';

class LearnCategoryScreen extends StatelessWidget {
  const LearnCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.grey[100], // Light grey background
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
                borderColor: Colors.green, // Green border
                cardColor: Colors.green[50], // Light green tint
                textColor: Colors.green[800], // Dark green text/icon
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          LearnScreen(category: category),
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