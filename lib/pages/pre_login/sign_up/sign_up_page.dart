import 'package:first_app/pages/pre_login/sign_up/sign_up_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import 'package:provider/provider.dart';
import '../../../entity/User.dart'; // 确保路径正确

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
    // 在页面初始化时设置用户数据
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
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 108),
                  Text(
                    "Set a nickname",
                    style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 303, // 固定宽度303px
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: null,
                            border: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                            ),
                          ),
                          style: TextStyle(fontFamily: 'Poppins'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a username";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    "Set a password",
                    style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 303, // 固定宽度303px
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: null,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(fontFamily: 'Poppins'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 300),
                  Center(
                    child: GradientButton(
                      text: "Submit",
                      onPressed: () {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          context.read<SignUpModel>().setUsername(_usernameController.text);
                          context.read<SignUpModel>().setPassword(_passwordController.text);
                          context.read<SignUpModel>().signUp();
                        } else {
                          print('Form validation failed or _formKey is null');
                        }
                      },
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
