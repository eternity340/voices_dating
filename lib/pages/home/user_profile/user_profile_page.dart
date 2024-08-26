import 'package:first_app/pages/home/user_profile/components/user_profile_card.dart';
import 'package:first_app/pages/home/user_profile/components/user_profile_photo_wall.dart';
import 'package:first_app/pages/home/user_profile/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/bottom_options.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/attachment_entity.dart';
import '../../../entity/moment_entity.dart';
import '../../../image_res/image_res.dart';


class UserProfilePage extends StatelessWidget {
  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserProfileController(
      userDataEntity: Get.arguments['userDataEntity'],
      tokenEntity: Get.arguments['tokenEntity'],
    ));

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showSettingButton: false,
            showBackButton: true,
            child: Container(),
          ),
          Positioned(
            left: 318.w,
            top: 52.h,
            child: GestureDetector(
              onTap: () => showOptionsBottomSheet(context, controller),
              child: Image.asset(
                ImageRes.imagePathSettingButton,
                width: 40.w,
                height: 40.h,
              ),
            ),
          ), buildMainContent(controller),
          //buildBottomBar(controller),
        ],
      ),
    );
  }

  void showOptionsBottomSheet(BuildContext context, UserProfileController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomOptions(
          onFirstPressed: () {
            Navigator.pop(context);
            Get.toNamed('/message/private_chat/user_report', arguments: {
              'userDataEntity': controller.userDataEntity,
              'tokenEntity': controller.tokenEntity,
            });
          },
          onSecondPressed: () {
            Navigator.pop(context);
            showBlockUserDialog(context, controller);
          },
          onCancelPressed: () => Navigator.pop(context),
          firstText: ConstantData.reportButton,
          secondText: ConstantData.blockButton,
        );
      },
    );
  }

  void showBlockUserDialog(BuildContext context, UserProfileController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomMessageDialog(
          title: const Text(ConstantData.blockUserText),
          content: const Text(ConstantData.blockUserDialogText),
          onYesPressed: controller.blockUser,
        );
      },
    );
  }

  Widget buildMainContent(UserProfileController controller) {
    return Positioned.fill(
      top: 100.h,
      bottom: 0.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildProfileSection(controller),
            buildDetailsSection(controller),
          ],
        ),
      ),
    );
  }

  Widget buildProfileSection(UserProfileController controller) {
    return Stack(
      children: [
        UserProfilePhotoWall(userDataEntity: controller.userDataEntity),
        Positioned(
          top: 280.h,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 283.w,
              height: 166.h,
              child: UserProfileCard(
                userDataEntity: controller.userDataEntity,
                tokenEntity: controller.tokenEntity,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDetailsSection(UserProfileController controller) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadlineSection(controller),
          SizedBox(height: 50.h),
          buildMomentsSection(controller),
          SizedBox(height: 50.h),
          buildAboutMeSection(controller),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget buildHeadlineSection(UserProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ConstantData.headline, style: ConstantStyles.headlineStyle),
        SizedBox(height: 10.h),
        Text(controller.userDataEntity.headline ?? '', style: ConstantStyles.bodyTextStyle),
      ],
    );
  }

  Widget buildMomentsSection(UserProfileController controller) {
    return GestureDetector(
      onTap: () => Get.toNamed('/message/private_chat/user_moments', arguments: {
        'userDataEntity': controller.userDataEntity,
        'tokenEntity': controller.tokenEntity,
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ConstantData.moments, style: ConstantStyles.headlineStyle),
          SizedBox(height: 16.h),
          Container(
            height: 105.h,
            child: Obx(() {
              if (controller.moments.isEmpty) {
                return Center(
                  child: SpinKitCircle(
                    color: Color(0xFFABFFCF),
                    size: 50.0,
                  ),
                );
              } else {
                return buildMomentsListView(controller);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget buildMomentsListView(UserProfileController controller) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.moments.length,
      itemBuilder: (context, index) {
        final moment = controller.moments[index];
        return buildMomentItem(moment, controller);
      },
    );
  }

  Widget buildMomentItem(MomentEntity moment, UserProfileController controller) {
    final attachments = moment.attachments;
    if (attachments == null || attachments.isEmpty) return SizedBox.shrink();
    return GestureDetector(
      onTap: () => Get.toNamed('/message/private_chat/user_moments',
          arguments: {
        'userDataEntity': controller.userDataEntity,
        'tokenEntity': controller.tokenEntity,
      }),
      child: Container(
        width: 105.w,
        height: 105.h,
        margin: EdgeInsets.only(right: 16.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: buildAttachmentImage(attachments.first.url),
        ),
      ),
    );
  }

  Widget buildAttachmentImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return SizedBox.shrink();
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: 105.w,
      height: 105.h,
    );
  }

  Widget buildAboutMeSection(UserProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ConstantData.aboutMe, style: ConstantStyles.headlineStyle),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: [
            buildInfoRow(ImageRes.iconHeight,
                controller.userDataEntity.height != null
                    ? '${controller.userDataEntity.height}cm'
                    : ''),
            buildInfoRow(ImageRes.iconLanguage,
                controller.userDataEntity.language ?? ''),
          ],
        ),
      ],
    );
  }

  Widget buildInfoRow(String iconPath, String text) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 24.w,
          height: 24.h,
        ),
        SizedBox(width: 16.w),
        Text(
          text,
          style: ConstantStyles.bodyTextStyle,
        ),
      ],
    );
  }


}
