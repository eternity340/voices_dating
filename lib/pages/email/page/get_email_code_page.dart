import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../constants/constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../model/get_email_code_model.dart';

class GetMailCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: EdgeInsets.all(16.w), // 使用ScreenUtil进行适配
          child: Consumer<GetEmailCodeModel>(
            builder: (context, model, child) {
              String selectedDomain = '@gmail.com';
              List<String> emailDomains = [
                '@gmail.com',
                '@yahoo.com',
                '@outlook.com',
                '@icloud.com',
                '@qq.com'
              ];

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.h), // 使用ScreenUtil进行适配
                    Center(
                      child: Text(
                        ConstantData.welcomeText,
                        textAlign: TextAlign.center,
                        style: ConstantStyles.welcomeTextStyle,
                      ),
                    ),
                    SizedBox(height: 20.h), // 使用ScreenUtil进行适配
                    Padding(
                      padding: EdgeInsets.only(left: 16.w), // 使用ScreenUtil进行适配
                      child: Text(
                        ConstantData.enterEmailText,
                        textAlign: TextAlign.start,
                        style: ConstantStyles.enterEmailTextStyle,
                      ),
                    ),
                    SizedBox(height: 20.h), // 使用ScreenUtil进行适配
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: model.emailController,
                            decoration: InputDecoration(
                              labelText: ConstantData.emailLabelText,
                              border: UnderlineInputBorder(),
                              errorText: model.errorMessage,
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: ConstantStyles.emailTextStyle,
                          ),
                        ),
                        SizedBox(width: 10.w), // 使用ScreenUtil进行适配
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(top: 20.h), // 使用ScreenUtil进行适配
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r), // 使用ScreenUtil进行适配
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: selectedDomain,
                              items: emailDomains.map((String domain) {
                                return DropdownMenuItem<String>(
                                  value: domain,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w), // 使用ScreenUtil进行适配
                                    child: Text(
                                      domain,
                                      style: ConstantStyles.emailTextStyle,
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
                              underline: SizedBox(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 300.h), // 使用ScreenUtil进行适配
                    model.isLoading
                        ? CircularProgressIndicator()
                        : Center(
                      child: GradientButton(
                        text: ConstantData.nextButtonText,
                        onPressed: () => model.sendVerificationCode(context),
                        width: 200.w, // 使用ScreenUtil进行适配
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
