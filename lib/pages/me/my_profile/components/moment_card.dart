import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../entity/moment_entity.dart';

class MomentCard extends StatelessWidget {
  final MomentEntity moment;

  const MomentCard({Key? key, required this.moment}) : super(key: key);

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
      child: Padding(
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
                GestureDetector(
                  onTap: () {
                    // 第二个按钮的点击事件处理
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
                        image: NetworkImage(attachment.url ?? 'https://via.placeholder.com/137x174'), // Default placeholder image
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
    );
  }
}
