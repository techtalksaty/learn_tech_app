import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../screens/learn/learn_category_screen.dart';
import '../screens/quiz/quiz_category_screen.dart';
import '../screens/progress/progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const LearnCategoryScreen(),
    const QuizCategoryScreen(),
    const ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Basics'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Tech Basics',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Learn Computer Fundamentals Anytime Anywhere',
          style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 250, // Fixed width for uniform button size
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18, color: Colors.white),
              foregroundColor: Colors.white, // Text/icon color
            ),
            onPressed: () {
              // Navigate to Learn tab (index 1)
              context.findAncestorStateOfType<_HomeScreenState>()?._onItemTapped(1);
            },
            child: const Text('Continue Learning'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 250, // Fixed width for uniform button size
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18, color: Colors.white),
              foregroundColor: Colors.white, // Text/icon color
            ),
            onPressed: () {
              // Navigate to Quiz tab (index 2)
              context.findAncestorStateOfType<_HomeScreenState>()?._onItemTapped(2);
            },
            child: const Text('Start Quiz'),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Text(
            'Powered By - Satyarth Programming Hub',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}