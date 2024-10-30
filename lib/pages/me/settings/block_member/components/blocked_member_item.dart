import 'package:voices_dating/constants/constant_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants/Constant_styles.dart';
import '../../../../../entity/block_member_entity.dart';
import '../../../../../components/verified_tag.dart'; // 确保导入 VerifiedTag 组件

class BlockedMemberItem extends StatelessWidget {
  final BlockMemberEntity member;
  final VoidCallback onUnblock;

  const BlockedMemberItem({
    required this.member,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      child: Stack(
        children: [
          Positioned(
            left: 19.w,
            top: 32.h,
            child: CircleAvatar(
              backgroundImage: NetworkImage(member.avatar ?? ''),
              radius: 40.r,
            ),
          ),
          Positioned(
            left: 100.w,
            top: 30.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.username ?? '',
                  style: ConstantStyles.timelineDescTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (member.member == "1")
                      VerifiedTag(
                        text: 'Superior',
                        backgroundColor: Color(0xFFFFA6CB),
                        textColor: Colors.black,
                      ),
                    SizedBox(width: 8.w),
                    if (member.verified == "1")
                      VerifiedTag(
                        text: 'Photos verified',
                        backgroundColor: Color(0xFFD7FAAD),
                        textColor: Colors.black,
                      ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 19.w,
            top: 100.h,
            child: Container(
              width: 80.w,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF20E2D7), Color(0xFFD6FAAE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.5.r),
              ),
              child: ElevatedButton(
                onPressed: onUnblock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.5.r),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    ConstantData.unblockButton,
                    style: ConstantStyles.blockButtonStyle.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
