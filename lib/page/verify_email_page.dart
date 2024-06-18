import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/verify_email_provider.dart';
import '../model/verify_email_model.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  final String verificationKey;

  VerifyEmailPage({required this.email, required this.verificationKey});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final model = VerifyEmailModel(email: widget.email, verificationKey: widget.verificationKey);
    Provider.of<VerifyEmailProvider>(context, listen: false).initialize(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("验证邮箱")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<VerifyEmailProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "验证码已发送至 ${widget.email}。",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: "验证码",
                    border: OutlineInputBorder(),
                    errorText: provider.errorMessage,
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                provider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    provider.verifyEmail(_codeController.text.trim());
                  },
                  child: Text("验证"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
