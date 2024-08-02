import 'package:first_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import 'block_member_controller.dart';
import 'components/blocked_member_item.dart';


class BlockMemberPage extends StatelessWidget {
  final BlockMemberController controller = Get.put(BlockMemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showMiddleText: true,
            middleText: ConstantData.blockMembersText,
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
              decoration: ConstantStyles.blockMemberContainerDecoration,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.blockedMembers.isEmpty) {
                  return Center(child: Text(ConstantData.noBlockedMembersText));
                }
                return EasyRefresh(
                  header: ClassicalHeader(
                    refreshText: "Pull to refresh",
                    refreshReadyText: "Release to refresh",
                    refreshingText: "Refreshing...",
                    refreshedText: "Refresh completed",
                    refreshFailedText: "Refresh failed",
                  ),
                  onRefresh: controller.fetchBlockedMembers,
                  child: ListView.separated(
                    itemCount: controller.blockedMembers.length,
                    separatorBuilder: (context, index) => ConstantStyles.blockMemberDivider,
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