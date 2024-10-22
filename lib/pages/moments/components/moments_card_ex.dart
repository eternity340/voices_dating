import 'dart:convert';

import 'package:voices_dating/constants/constant_styles.dart';
import 'package:voices_dating/entity/attachment_entity.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/audio_player_widget.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../image_res/image_res.dart';
import '../../../service/global_service.dart';
import '../../../utils/shared_preference_util.dart';
import '../moments_detail/moments_detail_controller.dart';
import 'love_button.dart';

class MomentsCard extends StatelessWidget {
  final MomentEntity moment;
  final bool showButtons;
  final TokenEntity tokenEntity;
  final VoidCallback onLoveButtonPressed;

  const MomentsCard({
    Key? key,
    required this.moment,
    required this.tokenEntity,
    required this.onLoveButtonPressed,
    this.showButtons = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      width: 335.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000).withOpacity(0.0642),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarAndUsername(),
                SizedBox(height: 16.h),
                Text(
                  moment.timelineDescr ?? ConstantData.timelineDescrText,
                  style: ConstantStyles.timelineDescTextStyle,
                ),
                SizedBox(height: 16.h),
                _buildAttachments(),
              ],
            ),
          ),
          if (showButtons) _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildAvatarAndUsername() {
    return GestureDetector(
      onTap: onAvatarTap,
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: moment.avatar != null
                    ? NetworkImage(moment.avatar!)
                    : AssetImage(ImageRes.placeholderAvatar) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              moment.username ?? ConstantData.unknownText,
              style: ConstantStyles.momentUsernameTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildAttachments() {
    if (moment.attachments == null || moment.attachments!.isEmpty) {
      return SizedBox.shrink();
    }

    final imageAttachments = moment.attachments!.where((attachment) =>
    attachment.type == 1 || attachment.type == null).toList();

    final audioAttachments = moment.attachments!.where((attachment) =>
    attachment.type == 2).toList();

    if (moment.attachments!.length == 1) {
      final attachment = moment.attachments!.first;
      if (attachment.type == 1 || attachment.type == null) {
        return _buildImageAttachment(attachment);
      } else if (attachment.type == 2) {
        return _buildAudioAttachment(attachment);
      }
    }
    if (imageAttachments.isNotEmpty) {
      return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: imageAttachments.map((attachment) {
                return Container(
                  width: 137.09.w,
                  height: 174.h,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    image: DecorationImage(
                      image: attachment.url != null
                          ? NetworkImage(attachment.url!)
                          : AssetImage(ImageRes.placeholderAvatar) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }
    if (audioAttachments.isNotEmpty) {
      return Column(
        children: audioAttachments.map((attachment) => _buildAudioAttachment(attachment)).toList(),
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildImageAttachment(AttachmentEntity attachment) {
    return Container(
      width: 303.w,
      height: 400.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          image: attachment.url != null
              ? NetworkImage(attachment.url!)
              : AssetImage(ImageRes.placeholderAvatar) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAudioAttachment(AttachmentEntity attachment) {
    return Container(
      width: 303.w,
      height: 50.h,
      margin: EdgeInsets.only(bottom: 10.h),
      child: AudioPlayerWidget(audioPath: attachment.url ?? ''),
    );
  }

  Widget _buildButtons() {
    return Positioned(
      right: 16.w,
      top: 12.h,
      child: Row(
        children: [
          GestureDetector(
            onTap: navigateToPrivateChat,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: Color(0xFFF8F8F9),
              ),
              child: Center(
                child: Image.asset(
                  ImageRes.iconChatInactive,
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          LoveButton(
            moment: moment,
            onLikeChanged: (int isLike) {
              //Get.find<MomentsDetailController>().updateLikeStatus(isLike);
            },
          ),
        ],
      ),
    );
  }

  void onAvatarTap() async {
    final globalService = Get.find<GlobalService>();
    final userDataEntity = await globalService.getUserProfile(
      userId: moment.userId ?? '',
      //accessToken: tokenEntity.accessToken.toString(),
    );

    if (userDataEntity != null) {
      Get.toNamed(AppRoutes.messageUserProfile, arguments: {
        'userDataEntity': userDataEntity,
        'tokenEntity': tokenEntity,
      });
    } else {
      Get.snackbar('Error', 'Failed to load user profile');
    }
  }

  void navigateToPrivateChat() {
    ChattedUserEntity chattedUser = ChattedUserEntity(
      userId: moment.userId ?? '',
      username: moment.username ?? ConstantData.unknownText,
      avatar: moment.avatar,
    );
    final userDataJson = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.userToken);
    UserDataEntity? userData;
    if (userDataJson != null) {
      try {
        final Map<String, dynamic> userDataMap = json.decode(userDataJson);
        userData = UserDataEntity.fromJson(userDataMap);
      } catch (e) {
        print('Error parsing user data: $e');
      }
    }

    Get.toNamed(AppRoutes.messagePrivateChat, arguments: {
      'tokenEntity': tokenEntity,
      'chattedUser': chattedUser,
      'userDataEntity': userData,
    });
  }
}