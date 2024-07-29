import 'package:dio/dio.dart';
import 'package:first_app/entity/moment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/token_entity.dart';

class LoveButton extends StatefulWidget {
  final MomentEntity moment;
  final TokenEntity tokenEntity;

  const LoveButton({
    Key? key,
    required this.tokenEntity,
    required this.moment,
  }) : super(key: key);

  @override
  _LoveButtonState createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> {
  late bool isLoved;

  @override
  void initState() {
    super.initState();
    // Initialize isLoved based on the moment's liked property
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
            isLoved ? 'assets/images/icon_love_active.png' : 'assets/images/icon_love_inactive.png',
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
