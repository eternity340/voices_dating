import 'package:first_app/components/background.dart';
import 'package:dio/dio.dart'; // 导入 Dio 包
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../entity/block_member_entity.dart';

class BlockMemberPage extends StatelessWidget {
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showMiddleText: true,
            middleText: 'Block Member',
            showBackgroundImage: false,
            showBackButton: true,
            child: Container(),
          ),
          Positioned(
            top: 139.h,
            left: (ScreenUtil().screenWidth - 335.w) / 2,
            child: Container(
              width: 335.w,
              height: 680.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(24.r),
                backgroundBlendMode: BlendMode.srcOver,
              ),
              child: FutureBuilder<List<BlockMemberEntity>>(
                future: fetchBlockedMembers(tokenEntity.accessToken!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No blocked members'));
                  }

                  final blockedMembers = snapshot.data!;
                  return ListView.separated(
                    itemCount: blockedMembers.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Color(0xFFEBEBEB),
                      height: 1.h,
                      thickness: 1.h,
                      indent: 0.w,
                      endIndent: 0.w,
                    ),
                    itemBuilder: (context, index) {
                      final member = blockedMembers[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.h),
                        child: Row(
                          children: [
                            SizedBox(width: 19.w),
                            CircleAvatar(
                              backgroundImage: NetworkImage(member.avatar ?? ''),
                              radius: 31.r, // 调整头像半径以增大头像
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
                                  // 其他信息可以继续添加在这里
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
                                onPressed: () {
                                  // 按钮点击事件处理
                                },
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
                                    fontFamily: 'Poppins'
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 19.w), // 右侧添加一些间距
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<BlockMemberEntity>> fetchBlockedMembers(String token) async {
    try {
      // 创建 Dio 实例
      final dio = Dio();

      // 发起 GET 请求
      final response = await dio.get(
        'https://api.masonvips.com/v1/blocked_users',
        options: Options(
          headers: {
            'token': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BlockMemberEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load blocked members');
      }
    } catch (e) {
      throw Exception('Failed to load blocked members: $e');
    }
  }
}
