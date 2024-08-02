import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyCodeInput extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;

  VerifyCodeInput({required this.length, required this.onCompleted});

  @override
  _VerifyCodeInputState createState() => _VerifyCodeInputState();
}

class _VerifyCodeInputState extends State<VerifyCodeInput> {
  List<FocusNode> _focusNodes = [];
  List<TextEditingController> _controllers = [];
  List<String> _code = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      _focusNodes.add(FocusNode());
      _controllers.add(TextEditingController());
      _code.add('');
      _controllers[i].addListener(() {
        _onChanged(i, _controllers[i].text);
      });
    }
  }

  @override
  void dispose() {
    _focusNodes.forEach((node) => node.dispose());
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      value = value.substring(value.length - 1);
      _controllers[index].text = value;
    }
    _code[index] = value;
    if (value.isEmpty) {
      if (index > 0) {
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted && _focusNodes[index - 1].hasFocus) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        });
      }
    } else {
      if (index + 1 < widget.length) {
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted && !_focusNodes[index + 1].hasFocus) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
        });
      }
    }

    // Join the code list to form the current code
    String currentCode = _code.join();

    // Check if the code is complete and call the onCompleted callback
    if (currentCode.length == widget.length) {
      if (mounted) {
        widget.onCompleted(currentCode);
        FocusScope.of(context).unfocus();
      }
      return; // Exit early if code is complete
    }

    // Update state only if necessary
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.length, (index) {
          return SizedBox(
            width: 50.w, // Use ScreenUtil for width
            height: 70.h, // Use ScreenUtil for height
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onTap: () {
                _controllers[index].selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _controllers[index].value.text.length,
                );
              },
              onChanged: (value) {
                if (value.length > 1) {
                  value = value.substring(value.length - 1);
                  _controllers[index].text = value;
                }
                _onChanged(index, value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                counterText: '',
                contentPadding: EdgeInsets.symmetric(vertical: 20.h), // Use ScreenUtil for padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r), // Use ScreenUtil for border radius
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 24.sp, // Use ScreenUtil for font size
              ),
            ),
          );
        }),
      ),
    );
  }
}
