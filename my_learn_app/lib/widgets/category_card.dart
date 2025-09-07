import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CategoryCard extends StatefulWidget {
  final String category;
  final VoidCallback onTap;
  final Color? borderColor; // Custom border color
  final Color? cardColor; // Custom card background
  final Color? textColor; // Custom text/icon color

  const CategoryCard({
    required this.category,
    required this.onTap,
    this.borderColor,
    this.cardColor,
    this.textColor,
    super.key,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with SingleTickerProviderStateMixin {
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: widget.borderColor ?? Colors.grey[300]!, // Default grey border
              width: 2,
            ),
          ),
          color: widget.cardColor ?? Colors.white, // Default white background
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  categoryIcons[widget.category] ?? Icons.book,
                  size: 40,
                  color: widget.textColor ?? primaryColor, // Default primaryColor
                ),
                const SizedBox(height: 8),
                Text(
                  widget.category,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor ?? Colors.black, // Default black text
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}