import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../entity/block_member_entity.dart';

class BlockedMemberItem extends StatelessWidget {
  final BlockMemberEntity member;
  final VoidCallback onUnblock;

  const BlockedMemberItem({
    required this.member,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Row(
        children: [
          SizedBox(width: 19.w),
          CircleAvatar(
            backgroundImage: NetworkImage(member.avatar ?? ''),
            radius: 31.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.username ?? '',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: 93.w,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.5.r),
                ),
              ),
              child: Text(
                'unlock',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          SizedBox(width: 19.w),
        ],
      ),
    );
  }
}