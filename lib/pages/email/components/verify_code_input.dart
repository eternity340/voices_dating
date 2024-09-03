import 'package:first_app/pages/email/components/verification_box_cursor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyCodeInput extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final double itemWidth;
  final double itemHeight;
  final Color focusedBorderColor;
  final Color unfocusedBorderColor;
  final Color fillColor;
  final bool showCursor;
  final Color cursorColor;

  VerifyCodeInput({
    required this.length,
    required this.onCompleted,
    this.itemWidth = 50,
    this.itemHeight = 70,
    this.focusedBorderColor = const Color(0xFF20E2D7),
    this.unfocusedBorderColor = Colors.grey,
    this.fillColor = const Color(0xFFF4F4F4),
    this.showCursor = true,
    this.cursorColor = const Color(0xFF20E2D7),
  });

  @override
  _VerifyCodeInputState createState() => _VerifyCodeInputState();
}

class _VerifyCodeInputState extends State<VerifyCodeInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  List<String> _codeList = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _codeList = List.filled(widget.length, '');
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _codeList = value.split('');
      _codeList.addAll(List.filled(widget.length - _codeList.length, ''));
    });

    if (value.length == widget.length) {
      widget.onCompleted(value);
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              widget.length,
                  (index) => _buildInputBox(index),
            ),
          ),
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLength: widget.length,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _onChanged,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox(int index) {
    bool isFocused = _controller.text.length == index;
    bool hasValue = index < _controller.text.length;

    return Container(
      width: widget.itemWidth.w,
      height: widget.itemHeight.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFocused ? Colors.transparent : widget.fillColor,
        borderRadius: BorderRadius.circular(10.r),
        border: isFocused
            ? Border.all(
          color: widget.focusedBorderColor,
          width: 2,
        )
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            hasValue ? _codeList[index] : '',
            style: TextStyle(fontSize: 24.sp),
          ),
          if (widget.showCursor && isFocused)
            _buildCursor(),
        ],
      ),
    );
  }

  Widget _buildCursor() {
    return VerificationBoxCursor(
      color: widget.cursorColor,
      width: 2,
      indent: 10,
      endIndent: 10,
    );
  }
}

