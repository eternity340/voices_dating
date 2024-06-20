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
        appBar: AppBar(title: Text("Verify Email")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<VerifyEmailModel>(
            builder: (context, model, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verification code has been sent to $email。",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: model.codeController,
                    decoration: InputDecoration(
                      labelText: "Verification Code",
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
                    child: Text("Verification"),
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
