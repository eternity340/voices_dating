import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in_model.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("登录")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SignInModel>(
          builder: (context, model, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: model.emailController,
                  decoration: InputDecoration(
                    labelText: "电子邮件",
                    border: OutlineInputBorder(),
                    errorText: model.emailErrorMessage,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: model.passwordController,
                  decoration: InputDecoration(
                    labelText: "密码",
                    border: OutlineInputBorder(),
                    errorText: model.passwordErrorMessage,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                model.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: model.signIn,
                  child: Text("登录"),
                ),
                if (model.errorMessage != null) ...[
                  SizedBox(height: 20),
                  Text(
                    model.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}
