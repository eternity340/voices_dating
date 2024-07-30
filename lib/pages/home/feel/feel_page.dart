import 'package:first_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';

class FeelPage extends StatelessWidget {
  final TokenEntity tokenEntity = Get.arguments?['token'] as TokenEntity;
  final UserDataEntity userData = Get.arguments?['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: true,
            showBackgroundImage: true,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
