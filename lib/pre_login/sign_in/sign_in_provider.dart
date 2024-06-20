import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in_model.dart';

class SignInProvider extends StatelessWidget {
  final Widget child;

  const SignInProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInModel(),
      child: child,
    );
  }
}
