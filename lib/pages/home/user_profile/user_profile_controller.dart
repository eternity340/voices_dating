import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:first_app/entity/moment_entity.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/global_service.dart';
import '../../../utils/log_util.dart';
import '../../../utils/shared_preference_util.dart';
import '../../../components/custom_message_dialog.dart';

class UserProfileController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity userDataEntity;
  final DioClient dioClient = DioClient();
  final GlobalService globalService = Get.find<GlobalService>();
  RxList<MomentEntity> moments = <MomentEntity>[].obs;

  UserProfileController({required this.userDataEntity, required this.tokenEntity});

  @override
  void onInit() {
    super.onInit();
    loadMoments();
  }

  Future<void> loadMoments() async {
    try {
      moments.clear();
      final newMoments = await globalService.getMoments(
        userId: userDataEntity.userId ?? '',
        accessToken: tokenEntity.accessToken.toString(),
      );
      moments.value = newMoments;
    } catch (e) {
      LogUtil.e(message:e.toString());
      moments.value = [];
    }
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

  void blockUser() {
    dioClient.requestNetwork<Map<String, dynamic>>(
      method: Method.post,
      url: ApiConstants.blockUser,
      queryParameters: {
        'userId': userDataEntity.userId},
      options: Options(
          headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null && data['ret'] == true) {
          Get.back(); // 关闭当前页面
          Get.snackbar('Success', 'User has been blocked');
        } else {
          Get.snackbar('Error', 'Failed to block user');
        }
      },
      onError: (code, msg, data) {
        Get.snackbar('Error', msg);
      },
    );
  }
}