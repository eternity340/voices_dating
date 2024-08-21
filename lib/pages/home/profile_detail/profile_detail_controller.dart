import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../utils/shared_preference_util.dart';
import '../../../components/custom_message_dialog.dart';

class ProfileDetailController extends GetxController {
  final ListUserEntity userEntity;
  final TokenEntity tokenEntity;
  late UserDataEntity? userDataEntity;

  ProfileDetailController({required this.userEntity, required this.tokenEntity}) {
    _initUserData();
  }

  void _initUserData() {
    final userDataJson = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.selfEntity);
    if (userDataJson != null) {
      try {
        final Map<String, dynamic> userDataMap = json.decode(userDataJson);
        userDataEntity = UserDataEntity.fromJson(userDataMap);
      } catch (e) {
        _showErrorDialog();
      }
    } else {
      _showErrorDialog();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  void onWinkButtonPressed() {

  }

  void onCallButtonPressed() {

  }

  void onChatButtonPressed() {
    if (userDataEntity == null) {
      _showErrorDialog();
      return;
    }

    ChattedUserEntity chattedUser = ChattedUserEntity(
      userId: userEntity.userId,
      username: userEntity.username,
      avatar: userEntity.avatar,
    );

    Get.toNamed('/message/private_chat', arguments: {
      'token': tokenEntity,
      'chattedUser': chattedUser,
      'userData': userDataEntity
    });
  }

  void _showErrorDialog() {
    Get.dialog(
      CustomMessageDialog(
        title: Text('Error'),
        content: Text('User data not found. Please log in again.'),
        onYesPressed: () {
          Get.offAllNamed('/welcome');
        },
      ),
    );
  }
}