import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    } else if (value.isNotEmpty) {
      if (value.length > 1) {
        String pastedValue = value;
        for (int i = index; i < widget.length && pastedValue.isNotEmpty; i++) {
          _controllers[i].text = pastedValue[0];
          _code[i] = pastedValue[0];
          pastedValue = pastedValue.substring(1);
        }
        setState(() {});
      } else {
        _code[index] = value;
        setState(() {});
      }

      if (index + 1 < widget.length) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }

      String currentCode = _code.join();
      if (currentCode.length == widget.length) {
        widget.onCompleted(currentCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // Increased fixed height of each input field container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.length, (index) {
          return SizedBox(
            width: 54, // Increased width
            height: 70, // Increased height
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
                contentPadding: EdgeInsets.symmetric(vertical: 20.0), // Adjust vertical padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          );
        }),
      ),
    );
  }
}
