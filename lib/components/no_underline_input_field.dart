import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../constants/Constant_styles.dart';

class NoUnderlineInputField extends StatefulWidget {
  final String label;
  final bool isEmail;
  final TextEditingController controller;

  const NoUnderlineInputField({
    Key? key,
    required this.label,
    this.isEmail = false,
    required this.controller,
  }) : super(key: key);

  @override
  NoUnderlineInputFieldState createState() => NoUnderlineInputFieldState();
}

class NoUnderlineInputFieldState extends State<NoUnderlineInputField> {
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();

  final List<String> _emailSuffixes = [
    '@gmail.com',
    '@yahoo.com',
    '@hotmail.com',
    '@outlook.com',
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.isEmail) {
      if (widget.controller.text.endsWith('@')) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    }
    setState(() {});
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + renderBox.size.height,
        left: offset.dx,
        width: renderBox.size.width,
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: _emailSuffixes
                .map((suffix) => ListTile(
              title: Text(
                suffix,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                widget.controller.text = widget.controller.text.split('@')[0] + suffix;
                widget.controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controller.text.length));
                _removeOverlay();
              },
            ))
                .toList(),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: ConstantStyles.signEmailTextStyle,
        ),
        SizedBox(height: 8.h),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 48.h,
            maxHeight: 96.h,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            cursorColor: kPrimaryColor,
            style: ConstantStyles.inputTextStyle,
            maxLines: null,
            decoration: InputDecoration(
              hintText: null,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
