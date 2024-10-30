import 'dart:convert';

import 'package:voices_dating/constants/constant_styles.dart';
import 'package:voices_dating/entity/attachment_entity.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/audio_player_widget.dart';
import '../../../components/image_viewer_page.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../image_res/image_res.dart';
import '../../../service/global_service.dart';
import '../../../utils/shared_preference_util.dart';
import '../moments_controller.dart';
import 'love_button.dart';

class MomentsCard extends StatelessWidget {
  final MomentEntity moment;
  final UserDataEntity userDataEntity;
  final bool showButtons;
  final TokenEntity tokenEntity;

  const MomentsCard({
    Key? key,
    required this.moment,
    required this.tokenEntity,
    this.showButtons = true,
    required this.userDataEntity,
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
            width: 38.w,
            height: 38.h,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moment.username ?? ConstantData.unknownText,
                  style: ConstantStyles.momentUsernameTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  _formatDate(moment.timelineDate ?? 0),
                  style: ConstantStyles.momentUsernameTextStyle.copyWith(
                    fontSize: 10.sp,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAttachments() {
    if (moment.attachments == null || moment.attachments!.isEmpty) {
      return SizedBox.shrink();
    }

    // 过滤出图片附件
    final imageAttachments = moment.attachments!.where((attachment) =>
    attachment.type == 1 || attachment.type == null).toList();

    // 过滤出音频附件
    final audioAttachments = moment.attachments!.where((attachment) =>
    attachment.type == 2).toList();

    return Column(
      children: [
        if (imageAttachments.isNotEmpty)
          _buildImageAttachments(imageAttachments),
        if (audioAttachments.isNotEmpty) ...[
          SizedBox(height: 16.h),
          ...audioAttachments.map((attachment) => _buildAudioAttachment(attachment)),
        ],
      ],
    );
  }

  Widget _buildImageAttachments(List<AttachmentEntity> imageAttachments) {
    if (imageAttachments.length == 1) {
      return _buildSingleImageAttachment(imageAttachments.first);
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: imageAttachments.asMap().entries.map((entry) {
            int index = entry.key;
            AttachmentEntity attachment = entry.value;
            return GestureDetector(
              onTap: () {
                Get.to(() => ImageViewerPage(
                  imageUrls: imageAttachments.map((a) => a.url ?? '').toList(),
                  initialIndex: index,
                ));
              },
              child: Container(
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
              ),
            );
          }).toList(),
        ),
      );
    }
  }

  Widget _buildSingleImageAttachment(AttachmentEntity attachment) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ImageViewerPage(
          imageUrls: [attachment.url ?? ''],
          initialIndex: 0,
        ));
      },
      child: Container(
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
          SizedBox(width: 16.w),
          /*LoveButton(
            moment: moment,
            onLikeChanged: (int isLike) {
              moment.liked = isLike;
            },
          ),*/
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
    /*final userDataJson = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.userToken);
    UserDataEntity? userData;
    if (userDataJson != null) {
      try {
        final Map<String, dynamic> userDataMap = json.decode(userDataJson);
        userData = UserDataEntity.fromJson(userDataMap);
      } catch (e) {
        print('Error parsing user data: $e');
      }
    }*/


    Get.toNamed(AppRoutes.messagePrivateChat, arguments: {
      'tokenEntity': tokenEntity,
      'chattedUser': chattedUser,
      'userDataEntity': userDataEntity,
    });
  }

  String _formatDate(int timestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}