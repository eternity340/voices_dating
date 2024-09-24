import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../constants/Constant_styles.dart';
import '../filters_controller.dart';

class DistanceSelector extends StatelessWidget {
  final FiltersController controller;

  const DistanceSelector({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> distances = [50, 100, 200, 300, 500, 1000];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey[300]!, // 浅灰色边框
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distance',
            style: ConstantStyles.locationListStyle,
          ),
          SizedBox(height: 8.h),
          Obx(() => Text(
            'Matches with: ${_getDistanceLabel(controller.selectedDistance.value)}',
            style: ConstantStyles.followPromptsTextStyle,
          )),
          SizedBox(height: 16.h),
          Obx(() => Slider(
            value: _getSliderValue(controller.selectedDistance.value),
            min: 0,
            max: distances.length.toDouble(),
            divisions: distances.length,
            activeColor: Color(0xFF20E2D7),
            inactiveColor: Color(0xFF20E2D7).withOpacity(0.3),
            onChanged: (value) {
              controller.selectedDistance.value = _getDistanceFromSliderValue(value, distances);
            },
          )),
        ],
      ),
    );
  }

  double _getSliderValue(String? distance) {
    if (distance == null) return 6;
    final List<int> distances = [50, 100, 200, 300, 500, 1000];
    return distances.indexOf(int.parse(distance)).toDouble();
  }

  String? _getDistanceFromSliderValue(double value, List<int> distances) {
    if (value == distances.length) return null;
    return distances[value.round()].toString();
  }

  String _getDistanceLabel(String? distance) {
    if (distance == null) return 'Any Distance';
    int miles = int.parse(distance);
    double km = miles * 1.60934;
    return '$miles miles (${km.round()} km)';
  }
}
