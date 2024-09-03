import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerificationBoxCursor extends StatefulWidget {
  final Color color;
  final double width;
  final double indent;
  final double endIndent;

  VerificationBoxCursor({
    required this.color,
    this.width = 2,
    this.indent = 10,
    this.endIndent = 10,
  });

  @override
  _VerificationBoxCursorState createState() => _VerificationBoxCursorState();
}

class _VerificationBoxCursorState extends State<VerificationBoxCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: VerticalDivider(
        thickness: widget.width,
        color: widget.color,
        indent: widget.indent,
        endIndent: widget.endIndent,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
