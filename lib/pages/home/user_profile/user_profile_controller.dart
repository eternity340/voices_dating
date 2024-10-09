import 'package:dio/dio.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/entity/moment_entity.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../entity/ret_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../entity/wink_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/global_service.dart';
import '../../../utils/log_util.dart';
import '../../../components/custom_message_dialog.dart';
import '../components/wink_selection_bottom_sheet.dart';

class UserProfileController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity userDataEntity;
  final DioClient dioClient = DioClient.instance;
  final GlobalService globalService = Get.find<GlobalService>();
  RxList<MomentEntity> moments = <MomentEntity>[].obs;
  RxList<WinkEntity> winkTypes = <WinkEntity>[].obs;

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
    WinkSelectionBottomSheet.show(
      title: ConstantData.winkTitle,
      onItemSelected: (WinkEntity selectedWink) {
        _sendWink(selectedWink);
      },
    );
  }

  Future<void> _sendWink(WinkEntity selectedWink) async {
    final userData = await globalService.getUserData();
    DioClient.instance.requestNetwork<RetEntity>(
      method: Method.post,
      url: ApiConstants.setWinkedUser,
      options: Options(headers: {'token': tokenEntity.accessToken}),
      params: {
        'profId': userDataEntity.userId,
        'winkedType': selectedWink.id,
        'userId': userData!.userId,
      },
      onSuccess: (data) {
        if (data != null && data.ret) {
          Get.snackbar(ConstantData.successText, 'Wink sent successfully');
        } else {
          Get.snackbar(ConstantData.failedText, 'Failed to send wink');
        }
      },
      onError: (code, msg, data) {
        if(code == 30004019){
          Get.snackbar(ConstantData.sorryText, msg);
        }else{
          Get.snackbar(ConstantData.errorText, msg);
        }
      },
    );
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