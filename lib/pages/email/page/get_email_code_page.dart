import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
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
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // 改变对齐方式为顶部对齐
                      children: [
                        Expanded(
                          flex: 2,
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
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(top: 20), // 增加上边距以调整位置
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), // 圆角边框
                              color: Colors.white, // 白色背景
                            ),
                            child: DropdownButton<String>(
                              value: selectedDomain,
                              items: emailDomains.map((String domain) {
                                return DropdownMenuItem<String>(
                                  value: domain,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // 调整内边距
                                    child: Text(
                                      domain,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  selectedDomain = newValue;
                                  String emailText = model.emailController.text;
                                  if (emailText.contains('@')) {
                                    emailText = emailText.split('@')[0];
                                  }
                                  model.emailController.text = emailText + selectedDomain;
                                }
                              },
                              underline: SizedBox(), // 去掉下划线
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 400), // 调整间距
                    model.isLoading
                        ? CircularProgressIndicator()
                        : Center(
                      child: GradientButton(
                        text: "Next",
                        onPressed: () => model.sendVerificationCode(context), // 传递 context
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
