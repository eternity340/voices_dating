import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/coin_info_widget.dart';
import '../../../components/disable_audio_player_widget.dart';
import '../../../components/verified_tag.dart';
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
  final bool showCoinAndService;
  bool get hasVerifiedTag => userEntity.member == "1" || userEntity.verified == "1";

  FeelDetailCard({
    required this.userEntity,
    required this.tokenEntity,
    this.showCoinAndService = true, // 默认显示
  });



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleCardTap(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Container(
          width: 335.w,
          height: cardHeight,
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
        //accessToken: tokenEntity.accessToken!,
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
        if (hasVerifiedTag) photoVerifiedBadge(),
        userInfo(),
        audioPlayer(),
        if (showCoinAndService) ...[
          coinInfo(100),
          serviceInfo(),
        ],
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
      child: Row(
        children: [
          if (userEntity.member == "1")
            VerifiedTag(
              text: ConstantData.superiorText,
              backgroundColor: Colors.black,
              textColor: Colors.white,
            ),
          if (userEntity.member == "1")
            SizedBox(width: 8.w),
          if (userEntity.verified == "1")
            VerifiedTag(
              text: ConstantData.photosVerified,
              backgroundColor: Color(0xFFABFFCF),
              textColor: Colors.black,
            ),
        ],
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
      bottom: 10.h,
      child: CoinInfoWidget(
        coinAmount: coinAmount,
        timeText: ConstantData.oneHourText,
      ),
    );
  }

  Widget audioPlayer() {
    return Positioned(
      left: 120.w,
      bottom: showCoinAndService
          ? (hasVerifiedTag ? 90.h : 60.h)
          : (hasVerifiedTag ? 60.h : 30.h),
      child: userEntity.voice?.voiceUrl != null
          ? AudioPlayerWidget(audioPath: userEntity.voice!.voiceUrl!)
          : DisabledAudioPlayerWidget(),
    );
  }

  Widget serviceInfo() {
    return Positioned(
      left: 190.5.w,
      bottom: 10.h,
      child: Text(
        'Service: 45 persons',
        style: ConstantStyles.coinTimeTextStyle,
        textAlign: TextAlign.right,
      ),
    );
  }

  double get cardHeight {
    if (showCoinAndService && hasVerifiedTag) return 211.21.h;
    if (showCoinAndService && !hasVerifiedTag) return 181.h;
    if (!showCoinAndService && hasVerifiedTag) return 181.h;
    return 151.h; // 没有 coin/service 信息，也没有 VerifiedTag
  }
}
