import 'package:first_app/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/bottom_options.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../components/profile_bottom.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../image_res/image_res.dart';
import '../../../routes/app_routes.dart';
import '../components/profile_photo_wall.dart';
import '../components/profile_card.dart';
import 'profile_detail_controller.dart';

class ProfileDetailPage extends StatelessWidget {
  ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileDetailController(
      userEntity: Get.arguments['userEntity'],
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
            left: 308.w,
            top: 40.h,
            child: GestureDetector(
              onTap: () => showOptionsBottomSheet(context, controller),
              child: Image.asset(
                ImageRes.imagePathSettingButton,
                width: 40.w,
                height: 40.h,
              ),
            ),
          ),
          buildMainContent(controller),
          buildBottomBar(controller),
        ],
      ),
    );
  }

  void showOptionsBottomSheet(BuildContext context, ProfileDetailController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomOptions(
          onFirstPressed: () {
            Navigator.pop(context);
            Get.toNamed(AppRoutes.homeReport, arguments: {
              'userEntity': controller.userEntity,
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

  void showBlockUserDialog(BuildContext context, ProfileDetailController controller) {
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

  Widget buildMainContent(ProfileDetailController controller) {
    return Positioned.fill(
      top: 100.h,
      bottom: 72.h,
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

  Widget buildProfileSection(ProfileDetailController controller) {
    return Stack(
      children: [
        ProfilePhotoWall(userEntity: controller.userEntity),
        Positioned(
          top: 280.h,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 283.w,
              height: 166.h,
              child: ProfileCard(
                userEntity: controller.userEntity,
                tokenEntity: controller.tokenEntity,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDetailsSection(ProfileDetailController controller) {
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

  Widget buildHeadlineSection(ProfileDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ConstantData.headline, style: ConstantStyles.headlineStyle),
        SizedBox(height: 10.h),
        Text(controller.userEntity.headline ?? '', style: ConstantStyles.bodyTextStyle),
      ],
    );
  }

  Widget buildMomentsSection(ProfileDetailController controller) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.homeProfileMoments,
              arguments: {
                'tokenEntity': controller.tokenEntity,
                'userData': controller.userDataEntity,
                'userEntity': controller.userEntity
          }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              ConstantData.moments,
              style: ConstantStyles.headlineStyle),
          SizedBox(height: 16.h),
          Container(
            height: 105.h,
            child: controller.userEntity.lastTimeline?.isNotEmpty == true
                ? buildMomentsListView(controller)
                : Center(
              child: Text(
                ConstantData.noMomentsData,
                style: ConstantStyles.bodyTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMomentsListView(ProfileDetailController controller) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount:
      controller.userEntity.lastTimeline?.length ?? 0,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () =>
            Get.toNamed('/home/profile_detail/profile_moments',
                arguments: {
                  'tokenEntity': controller.tokenEntity,
                  'userData': controller.userDataEntity,
                  'userEntity': controller.userEntity
                }),
        child: buildMomentItem(
            controller.userEntity.lastTimeline?[index]),
      ),
    );
  }

  //decoupling
  Widget buildMomentItem(dynamic timeline) {
    if (timeline is! Map<String, dynamic>) return SizedBox.shrink();
    final attachments = timeline['attachments'] as List<dynamic>?;
    if (attachments == null || attachments.isEmpty) return SizedBox.shrink();

    return Row(
      children: attachments.map((attachment) => buildAttachmentImage(attachment)).toList(),
    );
  }

  Widget buildAttachmentImage(dynamic attachment) {
    if (attachment is! Map<String, dynamic>) return SizedBox.shrink();
    final imageUrl = attachment['url'] as String?;
    if (imageUrl == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          imageUrl,
          width: 105.w,
          height: 105.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 105.w,
            height: 105.h,
            color: Colors.grey,
            child: Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget buildAboutMeSection(ProfileDetailController controller) {
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
                controller.userEntity.height != null
                    ? '${controller.userEntity.height}cm'
                    : ''),
            buildInfoRow(ImageRes.iconLanguage,
                controller.userEntity.language ?? ''),
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

  Widget buildBottomBar(ProfileDetailController controller) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ProfileBottom(
        initialGradientButtonText: ConstantData.winkButton,
        onInitialGradientButtonPressed: controller.onWinkButtonPressed,
        onCallButtonPressed: controller.onCallButtonPressed,
        onChatButtonPressed: controller.onChatButtonPressed,
        tokenEntity: controller.tokenEntity,
      ),
    );
  }
}
