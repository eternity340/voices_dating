import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/list_user_entity.dart';

class ProfileCard extends StatelessWidget {
  final ListUserEntity userEntity;

  const ProfileCard({Key? key, required this.userEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.0642),
            offset: Offset(0, 7),
            blurRadius: 14,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 27.2, sigmaY: 27.2),
          child: Container(
            width: 283.w,
            height: 166.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userEntity.username ?? '',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Open Sans',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 9.w,
                        height: 9.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFABFFCF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 88.w,
                    height: 19.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFABFFCF),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Center(
                      child: Text(
                        'Photos verified',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Open Sans',
                          letterSpacing: 0.02,
                          color: Color(0xFF262626),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        userEntity.location?.country ?? '',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Open Sans',
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      const Text(
                        '|',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Open Sans',
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${userEntity.age ?? 0} years old',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Open Sans',
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
