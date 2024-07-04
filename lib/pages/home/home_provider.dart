import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';
import '../../../entity/token_entity.dart';

class HomePageProvider extends StatelessWidget {
  final Widget child;
  final TokenEntity tokenEntity;

  HomePageProvider({required this.child, required this.tokenEntity});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(tokenEntity),
      child: child,
    );
  }
}
