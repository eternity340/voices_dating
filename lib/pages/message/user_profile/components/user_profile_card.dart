import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/entity/user_data_entity.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/verified_tag.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../entity/token_entity.dart';
import '../../../../image_res/image_res.dart';
import '../../../../net/dio.client.dart';
import '../../../../components/audio_player_widget.dart';
import '../../../../components/disable_audio_player_widget.dart';

class UserProfileCard extends StatefulWidget {
  final UserDataEntity? userDataEntity;
  final TokenEntity tokenEntity;


  UserProfileCard({
    super.key,
    required this.userDataEntity,
    required this.tokenEntity});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<UserProfileCard> {
  late bool _isLiked;
  final DioClient dioClient = DioClient.instance;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.userDataEntity?.liked == 1;

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
                widget.userDataEntity?.username ?? '',
                style: ConstantStyles.usernameTextStyle,
              ),
              SizedBox(width: 8.w),
              if(widget.userDataEntity?.online == "0")
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
              if (widget.userDataEntity?.member == "1")
                VerifiedTag(text: ConstantData.superiorText,
                    backgroundColor: Colors.black,
                    textColor: Colors.white
                ),
              if (widget.userDataEntity?.member == "1")
                SizedBox(width: 8.w),
              if (widget.userDataEntity?.verified == "1")
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
                widget.userDataEntity?.location?.country ?? '',
                style: ConstantStyles.countryTextStyle,
              ),
              SizedBox(width: 4.w),
              Text(
                '|',
                style: ConstantStyles.countryTextStyle,
              ),
              SizedBox(width: 4.w),
              Text(
                '${widget.userDataEntity?.age ?? 0} years old',
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
      ],
    );
  }

  Widget buildAudioPlayer() {
    if (widget.userDataEntity?.voice != null && widget.userDataEntity!.voice!.voiceUrl != null) {
      return AudioPlayerWidget(audioPath: widget.userDataEntity!.voice!.voiceUrl!);
    } else {
      return DisabledAudioPlayerWidget();
    }
  }

  void _toggleLike() {
    if (_cannotToggleLike()) return;

    final newLikeStatus = !_isLiked;
    final url = newLikeStatus
        ? ApiConstants.likeUser
        : ApiConstants.cancelLikeUser;

    _updateLocalState(newLikeStatus);
    _sendLikeRequest(url, newLikeStatus);
  }

  bool _cannotToggleLike() {
    return widget.userDataEntity?.userId == null || widget.tokenEntity.accessToken == null;
  }

  void _updateLocalState(bool isLiked) {
    setState(() {
      _isLiked = isLiked;
      if (widget.userDataEntity != null) {
        widget.userDataEntity!.liked = isLiked
            ? (widget.userDataEntity!.liked ?? 0) + 1
            : (widget.userDataEntity!.liked ?? 1) - 1;
      }
    });
  }

  void _sendLikeRequest(String url, bool newLikeStatus) {
    dioClient.requestNetwork<void>(
      method: Method.post,
      url: url,
      params: {'userId': widget.userDataEntity!.userId},
      options: Options(headers: {'token': '${widget.tokenEntity.accessToken}'}),
      onSuccess: (data) {

      },
      onError: (code, msg, data) {
        _updateLocalState(!newLikeStatus);
      },
    );
  }
}
