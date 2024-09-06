import 'package:first_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/coin_info_widget.dart';
import '../../../components/disable_audio_player_widget.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../image_res/image_res.dart';
import '../../../components/audio_player_widget.dart';
import '../../../service/global_service.dart';
import '../../../utils/common_utils.dart';


class FeelDetailCard extends StatelessWidget {
  final ListUserEntity userEntity;
  final TokenEntity tokenEntity;
  final GlobalService globalService = Get.find<GlobalService>();

  FeelDetailCard({required this.userEntity, required this.tokenEntity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleCardTap(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Container(
          width: 335.w,
          height: 221.21.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 14.r,
                offset: Offset(0, 7.h),
              ),
            ],
          ),
          child: cardContent(),
        ),
      ),
    );
  }

  void handleCardTap(BuildContext context) async {
    CommonUtils.showLoading();
    try {
      final UserDataEntity? userDataEntity = await globalService.getUserProfile(
        userId: userEntity.userId!,
        accessToken: tokenEntity.accessToken!,
      );
      CommonUtils.hideLoading();

      if (userDataEntity != null) {
        Get.toNamed(
          AppRoutes.messageUserProfile,
          arguments: {
            'userDataEntity': userDataEntity,
            'tokenEntity': tokenEntity,
          },
        );
      }
    } catch (e) {
      CommonUtils.hideLoading();
      CommonUtils.showSnackBar(e.toString());
    }
  }

  Widget cardContent() {
    return Stack(
      children: [
        avatar(),
        photoVerifiedBadge(),
        userInfo(),
        coinInfo(100),
        audioPlayer(),
        serviceInfo(),
      ],
    );
  }

  Widget avatar() {
    return Positioned(
      left: 10.w,
      top: 10.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Image.network(
          userEntity.avatar ?? ImageRes.placeholderAvatar,
          width: 100.w,
          height: 129.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget photoVerifiedBadge() {
    return Positioned(
      left: 16.w,
      top: 147.h,
      child: Container(
        width: 88.w,
        height: 19.h,
        decoration: BoxDecoration(
          color: Color(0xFFABFFCF),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            ConstantData.photosVerified,
            style: ConstantStyles.photoVerifiedTextStyle,
          ),
        ),
      ),
    );
  }

  Widget userInfo() {
    return Positioned(
      left: 120.w,
      top: 18.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                userEntity.username ?? ConstantData.unKnowText,
                style: ConstantStyles.usernameDetailTextStyle,
              ),
              SizedBox(width: 6.w),
              if(userEntity.online == "0")
                Container(
                  width: 9.w,
                  height: 9.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFABFFCF),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                userEntity.location?.state ?? ConstantData.unKnowText,
                style: ConstantStyles.locationTextStyle,
              ),
              SizedBox(width: 4.w),
              Text(
                '|',
                style: ConstantStyles.locationTextStyle,
              ),
              SizedBox(width: 4.w),
              Text(
                userEntity.age?.toString() ?? ConstantData.unKnowText,
                style: ConstantStyles.locationTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget coinInfo(int coinAmount) {
    return Positioned(
      left: 10.w,
      bottom: 17.h,
      child: CoinInfoWidget(
        coinAmount: coinAmount,
        timeText: ConstantData.oneHourText,
      ),
    );
  }

  Widget audioPlayer() {
    return Positioned(
      left: 120.w,
      bottom: 90.h,
      child: userEntity.voice?.voiceUrl != null
          ? AudioPlayerWidget(audioPath: userEntity.voice!.voiceUrl!)
          : DisabledAudioPlayerWidget(),
    );
  }

  Widget serviceInfo() {
    return Positioned(
      left: 190.5.w,
      bottom: 17.h,
      child: Text(
        'Service: 45 persons',
        style: ConstantStyles.coinTimeTextStyle,
        textAlign: TextAlign.right,
      ),
    );
  }
}
