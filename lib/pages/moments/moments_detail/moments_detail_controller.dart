import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/ret_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../constants/constant_data.dart';
import '../../../image_res/image_res.dart';
import '../../../components/bottom_options.dart';
import '../../../net/api_constants.dart';
import '../../../net/dio.client.dart';
import '../../../routes/app_routes.dart';

class MomentsDetailController extends GetxController {
  final MomentEntity moment = Get.arguments['moment'];
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'];
  final UserDataEntity userData = Get.arguments['userDataEntity'];

  final isCommentInputVisible = false.obs;
  final commentController = TextEditingController();
  final commentContent = ''.obs;

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void toggleCommentInput() {
    if (isCommentInputVisible.value) {
      submitComment();
    } else {
      isCommentInputVisible.value = true;
    }
  }

  void onCommentChanged(String text) {
    commentContent.value = text;
  }

  List<Widget> buildLikeAvatars() {
    if (moment.likers == null) return [];

    return moment.likers!.map((liker) => Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          image: NetworkImage(liker.avatar?.toString() ?? ImageRes.placeholderAvatar),
          fit: BoxFit.cover,
        ),
      ),
    )).toList();
  }

  Future<void> submitComment() async {
    // ... (保持原有代码不变)
  }

  void refreshComments() {
    update();
  }

  void showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomOptions(
          onFirstPressed: () {
            Navigator.pop(context);
            Get.toNamed(AppRoutes.homeReport, arguments: {
              'userId': moment.userId,
              'tokenEntity': tokenEntity,
            });
          },
          onSecondPressed: () {
            Navigator.pop(context);
            showBlockUserDialog(context);
          },
          onCancelPressed: () => Navigator.pop(context),
          firstText: ConstantData.reportButton,
          secondText: ConstantData.blockButton,
        );
      },
    );
  }

  void showBlockUserDialog(BuildContext context, ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomMessageDialog(
          title: const Text(ConstantData.blockUserText),
          content: const Text(ConstantData.blockUserDialogText),
          onYesPressed: blockUser,
        );
      },
    );
  }

  void blockUser() {
    DioClient.instance.requestNetwork<RetEntity>(
      method: Method.post,
      url: ApiConstants.blockUser,
      queryParameters: {'userId': moment.userId},
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
