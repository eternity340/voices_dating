import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/entity/moment_entity.dart';
import 'package:voices_dating/entity/token_entity.dart';
import 'package:voices_dating/image_res/image_res.dart';
import 'package:voices_dating/net/api_constants.dart';

import '../../../net/dio.client.dart';

class LoveButton extends StatefulWidget {
  final MomentEntity moment;
  final TokenEntity tokenEntity;
  final VoidCallback onLoveButtonPressed;

  const LoveButton({
    Key? key,
    required this.tokenEntity,
    required this.moment,
    required this.onLoveButtonPressed,
  }) : super(key: key);

  @override
  _LoveButtonState createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> {
  late bool isLoved;
  final DioClient dioClient = DioClient.instance;

  @override
  void initState() {
    super.initState();
    isLoved = widget.moment.liked == 1;
  }

  Future<void> _likeMoment() async {
    dioClient.requestNetwork(
      method: Method.post,
      url: ApiConstants.likeTimeline,
      options: Options(
        headers: {
          'token': widget.tokenEntity.accessToken,
        },
      ),
      queryParameters: {
        'timelineId': widget.moment.timelineId,
      },
      onSuccess: (data) {
        setState(() {
          isLoved = true;
        });
        widget.onLoveButtonPressed();
      },
      onError: (code, msg, data) {
        print('Error: $msg');
      },
    );
  }

  Future<void> _cancelLikeMoment() async {
    dioClient.requestNetwork(
      method: Method.post,
      url: ApiConstants.cancelLikeTimeline,
      options: Options(
        headers: {
          'token': widget.tokenEntity.accessToken,
        },
      ),
      queryParameters: {
        'timelineId': widget.moment.timelineId,
      },
      onSuccess: (data) {
        setState(() {
          isLoved = false;
        });
        widget.onLoveButtonPressed();
      },
      onError: (code, msg, data) {
        print('Error: $msg');
      },
    );
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
