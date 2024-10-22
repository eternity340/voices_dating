import 'package:flutter_svg/svg.dart';
import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/pages/home/get_up/get_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/bottom_options.dart';
import '../../../components/empty_state_widget.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../image_res/image_res.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/common_utils.dart';
import '../../moments/components/moments_card.dart';
import '../../moments/moments_controller.dart';

class GetUpPage extends StatelessWidget {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    final GetUpController controller = Get.put(GetUpController());

    return Scaffold(
      body: Background(
        showBackButton: true,
        showMiddleText: true,
        middleText: ConstantData.viewedText,
        child: Stack(
          children: [
            Positioned(
              right: 10.w,
              top: 0.h,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return BottomOptions(
                        onFirstPressed: () {
                          Navigator.pop(context);
                          Get.toNamed(
                            AppRoutes.momentsAddMoment,
                            arguments: {
                              'tokenEntity': controller.tokenEntity,
                              'userDataEntity': controller.userDataEntity
                            },
                          );
                        },
                        onSecondPressed: () {},
                        onCancelPressed: () {
                          Navigator.pop(context);
                        },
                        firstText: ConstantData.addMomentsText,
                        secondText: '',
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                  );
                },
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageRes.settingsButtonImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10.w,
              top: 59.h,
              child: Container(
                width: 335.w,
                height: 750.h,
                child: Obx(() {
                  if (controller.isInitialLoading.value) {
                    return CommonUtils.loadingIndicator();
                  } else if (controller.hasError.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error occurred while loading data.'),
                          ElevatedButton(
                            onPressed: controller.initialFetchMoments,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return EasyRefresh(
                      controller: controller.easyRefreshController,
                      onRefresh: () async => controller.refreshMoments(),
                      onLoad: () async => controller.fetchMoments(),
                      child: controller.moments.isEmpty && !controller.isInitialLoading.value && !controller.isRefreshing.value
                          ? _buildEmptyState()
                          : ListView.builder(
                        itemCount: controller.moments.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.momentsMomentsDetail,
                                  arguments: {
                                    'moment': controller.moments[index],
                                    'tokenEntity': controller.tokenEntity,
                                    'userDataEntity': controller.userDataEntity
                                  });
                            },
                            child: MomentsCard(
                              moment: controller.moments[index],
                              tokenEntity: controller.tokenEntity,
                              userDataEntity: controller.userDataEntity,
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      imagePath: ImageRes.emptyMomentsImage,
      message: 'No moments available',
      textStyle: ConstantStyles.selectLocationStyle,
    );
  }

}

