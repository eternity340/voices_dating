import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';
import '../../../constants/constant_data.dart'; // Import constant data
import '../../../constants/constant_styles.dart'; // Import constant styles
import 'package:first_app/pages/pre_login/sign_up/sign_up_model.dart';

class SignUpPage extends StatefulWidget {
  final User user;

  SignUpPage({required this.user});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set user data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignUpModel>().setUser(widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0.w), // Responsive padding
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h), // Responsive height
                  Text(
                    ConstantData.nicknameTitle,
                    style: ConstantStyles.formLabelStyle,
                  ),
                  SizedBox(height: 20.h), // Responsive height
                  Container(
                    width: 303.w, // Responsive width
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: ConstantStyles.textFieldDecoration,
                      style: ConstantStyles.textFieldStyle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a username";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20.h), // Responsive height
                  Text(
                    ConstantData.passwordTitle,
                    style: ConstantStyles.formLabelStyle,
                  ),
                  SizedBox(height: 10.h), // Responsive height
                  Container(
                    width: 303.w, // Responsive width
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: ConstantStyles.textFieldDecoration,
                      obscureText: true,
                      style: ConstantStyles.textFieldStyle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 150.h), // Responsive height
                  Center(
                    child: GradientButton(
                      text: ConstantData.submitButtonText,
                      onPressed: () {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          context.read<SignUpModel>().setUsername(_usernameController.text);
                          context.read<SignUpModel>().setPassword(_passwordController.text);
                          context.read<SignUpModel>().signUp();
                        } else {
                          print('Form validation failed or _formKey is null');
                        }
                      },
                      width: 200.w, // Responsive width
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
