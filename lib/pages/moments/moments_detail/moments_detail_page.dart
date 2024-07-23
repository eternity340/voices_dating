import 'package:first_app/components/background.dart';
import 'package:first_app/entity/moment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../components/moments_card.dart';

class MomentsDetailPage extends StatelessWidget{
  final moment = Get.arguments['moment'] as MomentEntity;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackgroundImage: true,
            showSettingButton: true,
            showBackButton: true,
            child: Container(),
          ),
          Positioned(
            left: 20.w,
            top: 109.h,
            child: MomentsCard(
              showButtons: false,
              moment: moment
            ),
          ),
        ],
      ),
    );
  }
}