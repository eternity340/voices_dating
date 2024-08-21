import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import '../../constants/Constant_styles.dart';
import '../../constants/constant_data.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';
import '../../image_res/image_res.dart';


class VoicePage extends StatelessWidget {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final UserDataEntity? userData = Get.arguments['userData'] as UserDataEntity?;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: false,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
