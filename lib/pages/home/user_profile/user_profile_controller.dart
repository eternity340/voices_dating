import 'package:dio/dio.dart';
import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/entity/moment_entity.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../entity/ret_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/global_service.dart';
import '../../../utils/log_util.dart';
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

  void showErrorDialog() {
    Get.dialog(
      CustomMessageDialog(
        title: Text(ConstantData.failedBlocked),
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
      queryParameters: {'userId': userDataEntity.userId},
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

  void onWinkButtonPressed() {

  }

  void onCallButtonPressed() {

  }

  void onChatButtonPressed() {
    ChattedUserEntity chattedUser = ChattedUserEntity(
      userId: userDataEntity.userId,
      username: userDataEntity.username,
      avatar: userDataEntity.avatar,
    );

    Get.toNamed(AppRoutes.messagePrivateChat, arguments: {
      'tokenEntity': tokenEntity,
      'chattedUser': chattedUser,
      'userDataEntity': userDataEntity
    });
  }
}