import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/verify_email_model.dart';

class VerifyEmailProvider extends StatelessWidget {
  final Widget child;
  final String email;
  final String verificationKey;

  VerifyEmailProvider({required this.child, required this.email, required this.verificationKey});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VerifyEmailModel(email: email, verificationKey: verificationKey),
      child: child,
    );
  }
}
