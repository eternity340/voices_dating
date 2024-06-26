import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forget_pwd_model.dart';

class ForgetPwdPage extends StatelessWidget {
  const ForgetPwdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ForgetPwdModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Retrieve Password",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: model.emailController,
              decoration: const InputDecoration(
                labelText: "Enter your email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: model.isLoading ? null : () => model.sendResetEmail(),
              child: model.isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text("Send Reset Email"),
            ),
            if (model.errorMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                model.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
