import 'package:voices_dating/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../image_res/image_res.dart';
import '../../../../utils/common_utils.dart';
import '../../../../components/empty_state_widget.dart';
import 'block_member_controller.dart';
import 'components/blocked_member_item.dart';

class BlockMemberPage extends StatefulWidget {
  @override
  _BlockMemberPageState createState() => _BlockMemberPageState();
}

class _BlockMemberPageState extends State<BlockMemberPage> {
  final BlockMemberController controller = Get.put(BlockMemberController());
  late EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

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
            left: 10.w,
            right: 10.h,
            child: Container(
              width: 335.w,
              height: 680.h,
              decoration: ConstantStyles.blockMemberContainerDecoration,
              child: Obx(() {
                if (controller.isLoading.value && controller.page.value == 1) {
                  return CommonUtils.loadingIndicator();
                }
                if (controller.blockedMembers.isEmpty) {
                  return EmptyStateWidget(
                    imagePath: ImageRes.emptyUserListSvg,
                    message: ConstantData.noBlockedMembersText,
                    imageWidth: 200.w,
                    imageHeight: 200.h,
                    topPadding: 0.h,
                  );
                }
                return EasyRefresh(
                  controller: _easyRefreshController,
                  onRefresh: () async {
                    await controller.onRefresh();
                    _easyRefreshController.finishRefresh();
                    _easyRefreshController.resetLoadState();
                  },
                  onLoad: controller.hasMore.value
                      ? () async {
                    await controller.onLoading();
                    _easyRefreshController.finishLoad(
                      noMore: !controller.hasMore.value,
                    );
                  }
                      : null,
                  child: ListView.separated(
                    itemCount: controller.blockedMembers.length,
                    separatorBuilder: (context, index) =>
                    ConstantStyles.blockMemberDivider,
                    itemBuilder: (context, index) {
                      final member = controller.blockedMembers[index];
                      return BlockedMemberItem(
                        member: member,
                        onUnblock: () =>
                            controller.unblockUser(member.userId!),
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
