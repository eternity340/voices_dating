import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../constants/constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../image_res/image_res.dart';
import '../components/detail_bottom_bar.dart';
import '../components/comments_widget.dart';
import '../components/moments_card.dart';
import 'moments_detail_controller.dart';

class MomentsDetailPage extends StatelessWidget {
  final controller = Get.put(MomentsDetailController());

  @override
  Widget build(BuildContext context) {
    return Background(
      showBackgroundImage: true,
      showSettingButton: false,
      showBackButton: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              left: 20.w,
              top: 60.h,
              right: 20.w,
              bottom: 70.h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MomentsCard(
                      showButtons: false,
                      moment: controller.moment,
                      tokenEntity: controller.tokenEntity,
                      userDataEntity: controller.userData,
                      onLoveButtonPressed: () {},
                    ),
                    SizedBox(height: 10.h),
                    _buildLikesSection(),
                    SizedBox(height: 24.h),
                    _buildCommentsSection(),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 18.w,
              top: 0.h,
              child: GestureDetector(
                onTap: () => controller.showOptionsBottomSheet(context),
                child: Image.asset(
                  ImageRes.imagePathSettingButton,
                  width: 40.w,
                  height: 40.h,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Obx(() => DetailBottomBar(
                showMomentLikeButton: true,
                showCallButton: false,
                showMessageButton: false,
                gradientButtonText: controller.isCommentInputVisible.value ? ConstantData.sendText : ConstantData.commentText,
                onGradientButtonPressed: controller.toggleCommentInput,
                tokenEntity: controller.tokenEntity,
                moment: controller.moment,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikesSection() {
    return Container(
      width: 335.w,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ConstantData.likesText, style: ConstantStyles.titleStyle),
                SizedBox(width: 5.w),
                Text(controller.moment.likers?.length.toString() ?? '0', style: ConstantStyles.titleStyle),
              ],
            ),
            SizedBox(height: 16.h),
            if (controller.moment.likers != null && controller.moment.likers!.isNotEmpty)
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: controller.buildLikeAvatars(),
              ),
            if (controller.moment.likers == null || controller.moment.likers!.isEmpty)
              Container(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      width: 335.w,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ConstantData.commentsText, style: ConstantStyles.titleStyle),
            Obx(() => controller.isCommentInputVisible.value ? _buildCommentInput() : SizedBox()),
            GetBuilder<MomentsDetailController>(
              builder: (controller) => CommentWidget(
                moment: controller.moment,
                tokenEntity: controller.tokenEntity,
                key: UniqueKey(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      width: 335.w,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: TextField(
          controller: controller.commentController,
          style: ConstantStyles.commentInputStyle,
          onChanged: controller.onCommentChanged,
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            hintText: ConstantData.commentWriteText,
            hintStyle: ConstantStyles.commentHintStyle,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          ),
        ),
      ),
    );
  }


}
