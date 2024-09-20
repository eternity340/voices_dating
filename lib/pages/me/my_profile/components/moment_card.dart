import 'package:common_utils/common_utils.dart';
import 'package:voices_dating/entity/attachment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import '../../../../components/audio_player_widget.dart';
import '../../../../components/bottom_options.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/moment_entity.dart';
import '../../../../entity/ret_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../components/custom_message_dialog.dart';
import '../../../../image_res/image_res.dart';
import '../../../../net/api_constants.dart';
import '../../../../net/dio.client.dart';

class MomentCard extends StatelessWidget {
  final MomentEntity moment;
  final TokenEntity tokenEntity;
  final VoidCallback onDelete;

  const MomentCard({
    Key? key,
    required this.moment,
    required this.tokenEntity,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                _buildUserInfo(),
                SizedBox(height: 16.h),
                _buildDescription(),
                SizedBox(height: 16.h),
                _buildAttachments(),
              ],
            ),
          ),
          _buildSettingsButton(context),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      moment.timelineDescr ?? ConstantData.noDescription,
      style: ConstantStyles.descriptionStyle,
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(moment.avatar ?? ImageRes.placeholderAvatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            moment.username ?? ConstantData.unknownText,
            style: ConstantStyles.usernameMomentStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildAttachments() {
    if (moment.attachments == null || moment.attachments!.isEmpty) {
      return SizedBox.shrink();
    }

    // 过滤出图片附件（包括 type 为 null 的附件）
    final imageAttachments = moment.attachments!.where((attachment) =>
    attachment.type == 1 || attachment.type == null).toList();

    // 过滤出音频附件
    final audioAttachments = moment.attachments!.where((attachment) =>
    attachment.type == 2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageAttachments.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: imageAttachments.map((attachment) {
                return Container(
                  width: imageAttachments.length == 1 ? 303.w : 137.09.w,
                  height: imageAttachments.length == 1 ? 400.h : 174.h,
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
        if (audioAttachments.isNotEmpty) ...[
          SizedBox(height: 16.h),
          ...audioAttachments.map((attachment) => _buildAudioAttachment(attachment)),
        ],
      ],
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

  Widget _buildSettingsButton(BuildContext context) {
    return Positioned(
      left: 259.w,
      top: 12.h,
      child: GestureDetector(
        onTap: () => _showBottomOptions(context),
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageRes.settingsButtonImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }


  void _showBottomOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomOptions(
          onFirstPressed: () {
            Navigator.of(context).pop();
            _showDeleteConfirmation(context);
          },
          onSecondPressed: () {},
          onCancelPressed: () {
            Navigator.of(context).pop();
          },
          firstText: 'Delete',
          secondText: '',
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomMessageDialog(
          title: Text(ConstantData.confirmDel),
          content: Text(ConstantData.deleteMomentContent),
          onYesPressed: () {
            _deleteMoment(context);
          },
        );
      },
    );
  }

  Future<void> _deleteMoment(BuildContext context) async {
    try {
      await DioClient.instance.requestNetwork<RetEntity>(
        method: Method.post,
        url: ApiConstants.delTimeline,
        queryParameters: {'timelineId': moment.timelineId},
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null && data.ret == true) {
            onDelete();
          } else {
            LogUtil.e('delete failed');
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(msg);
        },
      );
    } catch (e) {
      LogUtil.e(e.toString());
    }
  }

}
