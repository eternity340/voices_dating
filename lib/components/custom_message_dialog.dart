import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return CupertinoAlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black, // Text color for 'No'
            ),
            child: Text('No'),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onYesPressed(); // Call the provided function
          },
          child: const DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.red,
            ),
            child: Text('Yes'),
          ),
        ),
      ],
    );
  }
}
