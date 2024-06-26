import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'welcome_model.dart';

class WelcomeProvider extends StatelessWidget {
  final Widget child;

  WelcomeProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WelcomeModel(),
      child: child,
    );
  }
}
