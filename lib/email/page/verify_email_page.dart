import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/verify_email_model.dart';
import '../provider/verify_email_provider.dart';


class VerifyEmailPage extends StatelessWidget {
  final String email;
  final String verificationKey;

  VerifyEmailPage({required this.email, required this.verificationKey});

  @override
  Widget build(BuildContext context) {
    return VerifyEmailProvider(
      email: email,
      verificationKey: verificationKey,
      child: Scaffold(
        appBar: AppBar(title: Text("验证邮箱")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<VerifyEmailModel>(
            builder: (context, model, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "验证码已发送至 $email。",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: model.codeController,
                    decoration: InputDecoration(
                      labelText: "验证码",
                      border: OutlineInputBorder(),
                      errorText: model.errorMessage,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  model.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: model.verifyEmail,
                    child: Text("验证"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
