import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pre_login/components/gradient_btn.dart';
import '../components/background.dart';
import '../model/get_email_code_model.dart';

class GetMailCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<GetEmailCodeModel>(
            builder: (context, model, child) {
              String selectedDomain = '@gmail.com';
              List<String> emailDomains = ['@gmail.com', '@yahoo.com', '@outlook.com', '@icloud.com', '@qq.com'];

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const Center(
                      child: Text(
                        "Welcome",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          height: 44 / 32,
                          letterSpacing: -0.02,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Please enter your email",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8E8E93),
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: model.emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: UnderlineInputBorder(),
                              errorText: model.errorMessage,
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18, // 调整为18sp
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedDomain,
                          items: emailDomains.map((String domain) {
                            return DropdownMenuItem<String>(
                              value: domain,
                              child: Text(
                                domain,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18, // 调整为18sp
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            selectedDomain = newValue!;
                            model.emailController.text = model.emailController.text.split('@')[0] + selectedDomain;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 400), // 调整间距
                    model.isLoading
                        ? CircularProgressIndicator()
                        : Center( // 将按钮居中显示
                      child: GradientButton(
                        text: "Next",
                        onPressed: model.sendVerificationCode,
                        width: 200,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
