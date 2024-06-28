import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../constants.dart';
import '../sign_in_model.dart';
import 'package:get/get.dart' as getx;

class SignForm extends StatelessWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SignInModel>(context);

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          const Text(
            "Enter your email",
            style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontFamily: 'Poppins'),
          ),
          SizedBox(height: 20),
          Container(
            width: 303, // 固定宽度303px
            child: TextFormField(
              controller: model.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
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
              style: const TextStyle(fontFamily: 'Poppins'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          const Text(
            "Enter your password",
            style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontFamily: 'Poppins'),
          ),
          SizedBox(height: 10),
          Container(
            width: 303, // 固定宽度303px
            child: TextFormField(
              controller: model.passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
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
              style: const TextStyle(fontFamily: 'Poppins'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 200),
          Center(
            child: GradientButton(
              text: "Submit",
              onPressed: model.isLoading ? (){} : () => model.signIn(),
            ),
          ),
          TextButton(
            onPressed: () {
              getx.Get.toNamed('/forget_pwd'); // Navigate using GetX
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: const Text(
              "Forget Password?",
              style: TextStyle(color: kPrimaryColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
