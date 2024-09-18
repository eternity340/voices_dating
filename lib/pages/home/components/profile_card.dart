import 'dart:ui';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/disable_audio_player_widget.dart';
import '../../../components/verified_tag.dart';
import '../../../constants/Constant_styles.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../image_res/image_res.dart';
import '../../../net/dio.client.dart';
import '../../../components/audio_player_widget.dart';

class ProfileCard extends StatefulWidget {
  final ListUserEntity? userEntity;
  final TokenEntity tokenEntity;

  const ProfileCard({Key? key, required this.userEntity, required this.tokenEntity}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late bool _isLiked;
  final DioClient dioClient = DioClient.instance;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.userEntity?.liked == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 283.w,
          height: 166.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: const [
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
              child: Container(),
            ),
          ),
        ),
        Positioned(
          left: 16.w,
          top: 16.h,
          child: Row(
            children: [
              Text(
                widget.userEntity?.username ?? '',
                style: ConstantStyles.usernameTextStyle,
              ),
              SizedBox(width: 8.w),
              if(widget.userEntity?.online == "0")
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
        ),
        Positioned(
          left: 16.w,
          top: 47.h,
          child: Row(
            children: [
              if (widget.userEntity?.member == "1")
                VerifiedTag(text: ConstantData.superiorText,
                    backgroundColor: Colors.black,
                    textColor: Colors.white
                ),
              if (widget.userEntity?.member == "1")
                SizedBox(width: 8.w),
              if (widget.userEntity?.verified == "1")
                VerifiedTag(
                  text: ConstantData.photosVerified,
                  backgroundColor: Color(0xFFABFFCF),
                  textColor: Colors.black,
                ),
            ],
          ),
        ),
        Positioned(
          left: 16.w,
          top: 75.h,
          child: Row(
            children: [
              Text(
                widget.userEntity?.location?.country ?? '',
                style: ConstantStyles.countryTextStyle,
              ),
              SizedBox(width: 4.w),
               Text(
                '|',
                style: ConstantStyles.countryTextStyle
              ),
              SizedBox(width: 4.w),
              Text(
                '${widget.userEntity?.age ?? 0} years old',
                style: ConstantStyles.countryTextStyle,
              ),
            ],
          ),
        ),
        Positioned(
          left: 16.w,
          top: 116.h,
          child: buildAudioPlayer(),
        ),
        Positioned(
          left: 230.w,
          top: 125.h,
          child: GestureDetector(
            onTap: _toggleLike,
            child: Image.asset(
              _isLiked
                  ? ImageRes.iconLoveSelect
                  : ImageRes.iconLoveUnselect,
              width: 20.83.w,
              height: 20.73.h,
            ),
          ),
        ),
        /*Positioned(
          left: 256.w,
          top: 126.h,
          child: Text(
            '${widget.userEntity?.liked ?? 0}',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              color: Colors.black,
            ),
          ),
        ),*/
      ],
    );
  }

  void _toggleLike() {
    if (cannotToggleLike()) return;

    final newLikeStatus = !_isLiked;
    final url = newLikeStatus ? ApiConstants.likeUser : ApiConstants.cancelLikeUser;

    updateLocalState(newLikeStatus);
    sendLikeRequest(url, newLikeStatus);
  }

  bool cannotToggleLike() {
    return widget.userEntity?.userId == null || widget.tokenEntity.accessToken == null;
  }

  void updateLocalState(bool isLiked) {
    setState(() {
      _isLiked = isLiked;
      if (widget.userEntity != null) {
        widget.userEntity!.liked = isLiked
            ? (widget.userEntity!.liked ?? 0) + 1
            : (widget.userEntity!.liked ?? 1) - 1;
      }
    });
  }

  void sendLikeRequest(String url, bool isLiked) {
    dioClient.requestNetwork<void>(
      method: Method.post,
      url: url,
      params: {'userId': widget.userEntity!.userId},
      options: Options(headers: {'token': '${widget.tokenEntity.accessToken}'}),
      onSuccess: (data) {
      },
      onError: (code, msg, data) {
        LogUtil.e(msg);
        updateLocalState(!isLiked);
      },
    );
  }

  Widget buildAudioPlayer() {
    if (widget.userEntity?.voice != null && widget.userEntity!.voice!.voiceUrl != null) {
      return AudioPlayerWidget(audioPath: widget.userEntity!.voice!.voiceUrl!);
    } else {
      return DisabledAudioPlayerWidget();
    }
  }

}