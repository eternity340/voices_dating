import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/ret_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../net/dio.client.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/shared_preference_util.dart';
import '../../../components/custom_message_dialog.dart';

class ProfileDetailController extends GetxController {
  final ListUserEntity userEntity;
  final TokenEntity tokenEntity;
  late UserDataEntity? userDataEntity;
  final DioClient dioClient = DioClient();

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

    Get.toNamed(AppRoutes.messagePrivateChat, arguments: {
      'tokenEntity': tokenEntity,
      'chattedUser': chattedUser,
      'userDataEntity': userDataEntity
    });
  }

  void _showErrorDialog() {
    Get.dialog(
      CustomMessageDialog(
        title: Text(ConstantData.failedText),
        content: Text(ConstantData.userDataNotFound),
        onYesPressed: () {
          Get.offAllNamed(AppRoutes.welcome);
        },
      ),
    );
  }

  void blockUser() {
    DioClient.instance.requestNetwork<RetEntity>(
      method: Method.post,
      url: ApiConstants.blockUser,
      queryParameters: {'userId': userEntity.userId},
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null && data.ret) {
          Get.back();
          Get.snackbar(ConstantData.successText, ConstantData.userHasBlocked);
        } else {
          Get.snackbar(ConstantData.failedText, ConstantData.failedBlocked);
        }
      },
      onError: (code, msg, data) {
        Get.snackbar(ConstantData.errorText, msg);
      },
    );
  }
}