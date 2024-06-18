import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/get_email_code_model.dart';

class GetEmailCodeProvider extends StatelessWidget {
  final Widget child;

  GetEmailCodeProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetEmailCodeModel(),
      child: child,
    );
  }
}
