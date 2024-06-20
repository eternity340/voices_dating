import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/get_email_code_model.dart';

class GetMailCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get email verification code")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<GetEmailCodeModel>(
          builder: (context, model, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Please enter your email to receive the verification code。",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: model.emailController,
                  decoration: InputDecoration(
                    labelText: "email",
                    border: OutlineInputBorder(),
                    errorText: model.errorMessage,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                model.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: model.sendVerificationCode,
                  child: Text("send verification code"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
