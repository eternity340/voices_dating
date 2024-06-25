import 'package:flutter/material.dart';

class SelectBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  SelectBox({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 69,
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: Color(0xFFABFFCF), width: 2)
              : null,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: -0.01,
                ),
              ),
            ),
            Spacer(),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFAAFCCF) : Color(0xFFE1E1E1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: isSelected
                  ? const Center(
                child: Icon(
                  Icons.check,
                  size: 20,
                  color: Color(0xFF3B3B3B),
                ),
              )
                  : null,
            ),
            SizedBox(width: 16), // Add some space to the right
          ],
        ),
      ),
    );
  }
}
