import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/path_box.dart';

class NotificationPage extends StatelessWidget {
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: true,
            showSettingButton: false,
            showBackgroundImage: false,
            showMiddleText: true,
            middleText: '     ',
            child: Container(),
          ),
        ],
      ),
    );
  }
}
