import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forget_pwd_model.dart';

class ForgetPwdProvider extends StatelessWidget {
  final Widget child;

  const ForgetPwdProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgetPwdModel(),
      child: child,
    );
  }
}

