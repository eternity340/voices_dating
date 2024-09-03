import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
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
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(moment.avatar ?? ImageRes.placeholderAvatar), // Default placeholder image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        moment.username ?? ConstantData.unknownText,
                        style: ConstantStyles.usernameMomentStyle, // 使用常量中的样式
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  moment.timelineDescr ?? ConstantData.noDescription,
                  style: ConstantStyles.descriptionStyle,
                ),
                SizedBox(height: 16.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: moment.attachments?.map((attachment) {
                      return Container(
                        width: 137.09.w,
                        height: 174.h,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          image: DecorationImage(
                            image: NetworkImage(attachment.url ?? ImageRes.placeholderAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList() ?? [],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 259.w,
            top: 12.h,
            child: GestureDetector(
              onTap: () {
                _showBottomOptions(context);
              },
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
          ),
        ],
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
