import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import '../../../../components/bottom_options.dart';
import '../../../../entity/moment_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../components/custom_message_dialog.dart';

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
                          image: NetworkImage(moment.avatar ?? ''), // Default placeholder image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        moment.username ?? 'Unknown',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14.sp,
                          height: 24 / 14,
                          color: Color(0xFF000000),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  moment.timelineDescr ?? 'No description available',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    height: 24 / 16,
                    letterSpacing: -0.01,
                    color: Color(0xFF000000),
                  ),
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
                            image: NetworkImage(attachment.url ?? 'assets/images/placeholder1.png'), // Default placeholder image
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
                    image: AssetImage('assets/images/button_round_setting.png'),
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
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this moment?'),
          onYesPressed: () {
            _deleteMoment(context);
          },
        );
      },
    );
  }

  Future<void> _deleteMoment(BuildContext context) async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        'https://api.masonvips.com/v1/del_timeline',
        queryParameters: {
          'timelineId': moment.timelineId,
        },
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
        onDelete();
      } else {
        print('Failed to delete moment');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
