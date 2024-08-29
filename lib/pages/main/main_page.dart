/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/all_navigation_bar.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';
import '../../service/app_service.dart';
import '../../utils/log_util.dart';
import '../../utils/shared_preference_util.dart';
import '../home/home_page.dart';
import '../me/me_page.dart';
import '../message/message_page.dart';
import '../moments/moments_page.dart';
import 'dart:convert';

class MainPage extends StatelessWidget {
  late final TokenEntity tokenEntity;
  late final UserDataEntity? userData;
  final RxInt currentIndex = 0.obs;

  MainPage() {
    _initData();
  }

  void _initData() {
    final tokenJson = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.userToken);
    if (tokenJson != null) {
      tokenEntity = TokenEntity.fromJson(json.decode(tokenJson));
    } else {
      LogUtil.e(message: 'token error');
    }

    userData = Get.find<AppService>().selfUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => IndexedStack(
            index: currentIndex.value,
            children: [
              HomePage(),
              MomentsPage(),
              MessagePage(),
              MePage(),
            ],
          )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AllNavigationBar(
              tokenEntity: tokenEntity,
              userData: userData,
              currentIndex: currentIndex,
            ),
          ),
        ],
      ),
    );
  }
}*/
