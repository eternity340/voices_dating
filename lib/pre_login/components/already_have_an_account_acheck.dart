import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function()? press;
  const AlreadyHaveAnAccountCheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "没有账户？ " : "已经有账户？ ",
          style: const TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "注册" : "登录",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
