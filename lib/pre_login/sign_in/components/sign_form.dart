import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../sign_in_model.dart';

import 'package:get/get.dart' as getx;


class SignForm extends StatelessWidget {
  const SignForm({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SignInModel>(context);

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: model.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: kPrimaryLightColor,
              errorText: model.emailErrorMessage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: model.passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: kPrimaryLightColor,
                errorText: model.passwordErrorMessage,
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: model.isLoading ? null : () => model.signIn(),
            child: model.isLoading
                ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
                : Text(
              "SIGN IN".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextButton(
            onPressed: () {
              getx.Get.toNamed('/forget_pwd'); // 使用 GetX 导航
            },
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: const Text(
              "Forget Password?",
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
