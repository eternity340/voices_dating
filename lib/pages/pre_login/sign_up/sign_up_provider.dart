import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_up_model.dart';

class SignUpProvider extends StatelessWidget {
  final Widget child;

  const SignUpProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpModel(),
      child: child,
    );
  }
}
