import 'package:first_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../entity/block_member_entity.dart';
import 'block_member_controller.dart';

class BlockMemberPage extends StatelessWidget {
  final BlockMemberController controller = Get.put(BlockMemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showMiddleText: true,
            middleText: 'Block Members',
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.blockedMembers.isEmpty) {
                  return Center(child: Text('No blocked members'));
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchBlockedMembers,
                  child: ListView.separated(
                    itemCount: controller.blockedMembers.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Color(0xFFEBEBEB),
                      height: 1.h,
                      thickness: 1.h,
                    ),
                    itemBuilder: (context, index) {
                      final member = controller.blockedMembers[index];
                      return BlockedMemberItem(
                        member: member,
                        onUnblock: () => controller.unblockUser(member.userId!),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

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
