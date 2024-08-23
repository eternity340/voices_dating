import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constant_data.dart';
import '../constants/constant_styles.dart';

class CustomMessageDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final VoidCallback onYesPressed;

  const CustomMessageDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onYesPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      child: CupertinoAlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: DefaultTextStyle(
              style: ConstantStyles.dialogCancelTextStyle,
              child: Text(ConstantData.cancelText),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              onYesPressed();
            },
            child: DefaultTextStyle(
              style: ConstantStyles.yesTextStyle,
              child: Text(ConstantData.yesText),
            ),
          ),
        ],
      ),
    );
  }
}