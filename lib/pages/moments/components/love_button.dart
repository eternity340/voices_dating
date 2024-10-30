import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/entity/moment_entity.dart';
import 'package:voices_dating/image_res/image_res.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/service/token_service.dart';

import '../../../net/dio.client.dart';

class LoveButton extends StatefulWidget {
  final MomentEntity moment;
  final Function(int) onLikeChanged;

  const LoveButton({
    super.key,
    required this.moment,
    required this.onLikeChanged,
  });

  @override
  _LoveButtonState createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> with SingleTickerProviderStateMixin {
  late int isLike;
  final DioClient dioClient = DioClient.instance;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    isLike = widget.moment.liked!;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      isLike = isLike == 1 ? 0 : 1;
    });
    _animateButton();
    _debounceLikeAction();
  }

  void _animateButton() {
    if (!_isAnimating) {
      _isAnimating = true;
      _controller.forward().then((_) {
        _controller.reverse().then((_) {
          _isAnimating = false;
        });
      });
    }
  }

  void _debounceLikeAction() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (isLike == 1) {
        _likeMoment();
      } else {
        _cancelLikeMoment();
      }
    });
  }

  Future<void> _likeMoment() async {
    widget.onLikeChanged.call(1);

    dioClient.requestNetwork(
      method: Method.post,
      url: ApiConstants.likeTimeline,
      options: Options(
        headers: {
          'token': await TokenService.instance.getToken(),
        },
      ),
      queryParameters: {
        'timelineId': widget.moment.timelineId,
      },
      onSuccess: (data) {
        // 成功后的处理
      },
      onError: (code, msg, data) {
        print('Error: $msg');
        // 错误处理，可能需要回滚状态
        setState(() {
          isLike = 0;
        });
      },
    );
  }

  Future<void> _cancelLikeMoment() async {
    widget.onLikeChanged(0);

    dioClient.requestNetwork(
      method: Method.post,
      url: ApiConstants.cancelLikeTimeline,
      options: Options(
        headers: {
          'token': await TokenService.instance.getToken(),
        },
      ),
      queryParameters: {
        'timelineId': widget.moment.timelineId,
      },
      onSuccess: (data) {
        // 成功后的处理
      },
      onError: (code, msg, data) {
        print('Error: $msg');
        // 错误处理，可能需要回滚状态
        setState(() {
          isLike = 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: Colors.transparent,
          ),
          child: Center(
            child: Image.asset(
              isLike == 1 ? ImageRes.iconLoveActive : ImageRes.iconLoveInactive,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
