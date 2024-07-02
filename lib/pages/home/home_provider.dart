import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';

class HomePageProvider extends StatelessWidget {
  final Widget child;
  final String token;

  HomePageProvider({required this.child, required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(token),
      child: child,
    );
  }
}
