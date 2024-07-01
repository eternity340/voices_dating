import 'package:flutter/material.dart';

class HomeIconButton extends StatelessWidget {
  final String imagePath;
  final Color shadowColor;

  HomeIconButton({required this.imagePath, required this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: 120, // Adjust button size if needed
        height: 120, // Adjust button size if needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(0, 7),
              blurRadius: 15,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}
