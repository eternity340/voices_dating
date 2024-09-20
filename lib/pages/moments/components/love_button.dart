import 'package:dio/dio.dart';
import 'package:voices_dating/entity/moment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/token_entity.dart';
import '../../../image_res/image_res.dart';

class LoveButton extends StatefulWidget {
  final MomentEntity moment;
  final TokenEntity tokenEntity;
  final VoidCallback onLoveButtonPressed; // 添加回调函数

  const LoveButton({
    Key? key,
    required this.tokenEntity,
    required this.moment,
    required this.onLoveButtonPressed, // 添加回调函数
  }) : super(key: key);

  @override
  _LoveButtonState createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> {
  late bool isLoved;

  @override
  void initState() {
    super.initState();
    isLoved = widget.moment.liked == 1;
  }

  Future<void> _likeMoment() async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'https://api.masonvips.com/v1/like_timeline',
        options: Options(
          headers: {
            'token': widget.tokenEntity.accessToken,
          },
        ),
        queryParameters: {
          'timelineId': widget.moment.timelineId,
        },
      );

      if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
        setState(() {
          isLoved = true;
        });
        widget.onLoveButtonPressed(); // 调用回调函数
      } else {
        print('Error: ${response.data['message']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _cancelLikeMoment() async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'https://api.masonvips.com/v1/cancel_like_timeline',
        options: Options(
          headers: {
            'token': widget.tokenEntity.accessToken,
          },
        ),
        queryParameters: {
          'timelineId': widget.moment.timelineId,
        },
      );

      if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
        setState(() {
          isLoved = false;
        });
        widget.onLoveButtonPressed(); // 调用回调函数
      } else {
        print('Error: ${response.data['message']}');
      }
    } catch (e) {
      print('Error: $e');
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
            isLoved ? ImageRes.iconLoveActive : ImageRes.iconLoveInactive,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant LoveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.moment.liked != widget.moment.liked) {
      setState(() {
        isLoved = widget.moment.liked == 1;
      });
    }
  }
}
