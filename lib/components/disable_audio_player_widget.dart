import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import 'package:get/get.dart';

import '../constants/constant_data.dart';

class DisabledAudioPlayerWidget extends StatelessWidget {
  final int _barCount = 20;
  final Random _random = Random();

  DisabledAudioPlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showNoAudioMessage(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.h,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _buildBars(),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildBars() {
    final List<double> _barHeights = List.generate(_barCount, (_) => 10.h + _random.nextDouble() * 20.h);

    return SizedBox(
      width: 130.w,
      height: 30.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _barCount,
              (index) => Container(
            width: 2.w,
            height: _barHeights[index],
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
        ),
      ),
    );
  }

  void _showNoAudioMessage(BuildContext context) {
      Get.snackbar(ConstantData.failedText, 'This user has not yet recorded their own special audio.');
  }
}
