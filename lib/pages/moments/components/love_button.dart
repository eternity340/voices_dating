import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/token_entity.dart';

class LoveButton extends StatefulWidget {
  final String timelineId;
  final TokenEntity tokenEntity;

  const LoveButton({
    Key? key,
    required this.timelineId,
    required this.tokenEntity,
  }) : super(key: key);

  @override
  _LoveButtonState createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> {
  bool isLoved = false;

  Future<void> _likeMoment() async {
    final dio = Dio();
    final response = await dio.post(
      'https://api.masonvips.com/v1/like_timeline',
      options: Options(
        headers: {
          'token': widget.tokenEntity.accessToken,
        },
      ),
      queryParameters: {
        'timelineId': widget.timelineId,
      },
    );

    if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
      setState(() {
        isLoved = true;
      });
    } else {
      // 处理错误情况
      print('error: ${response.data['message']}');
    }
  }

  Future<void> _cancelLikeMoment() async {
    final dio = Dio();
    final response = await dio.post(
      'https://api.masonvips.com/v1/cancel_like_timeline',
      options: Options(
        headers: {
           'token': widget.tokenEntity.accessToken,
        },
      ),
      queryParameters: {
        'timelineId': widget.timelineId,
      },
    );

    if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
      setState(() {
        isLoved = false;
      });
    } else {
      // 处理错误情况
      print('Error: ${response.data['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLoved) {
          _cancelLikeMoment();
        } else {
          _likeMoment();
        }
      },
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: Color(0xFFF8F8F9),
        ),
        child: Center(
          child: Image.asset(
            isLoved ? 'assets/images/icon_love_active.png' : 'assets/images/icon_love_inactive.png',
            width: 24.w,
            height: 24.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
