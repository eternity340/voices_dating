import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../constants/Constant_styles.dart';
import '../components/distance_selector.dart';
import '../filters_controller.dart';
import 'option/live_in_option.dart';

class LocationFilter extends StatelessWidget {
  final FiltersController controller;

  const LocationFilter({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: ConstantStyles.locationListStyle),
          SizedBox(height: 16.h),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRadioOption('Anywhere', 'anywhere', controller),
              SizedBox(height: 12.h),
              _buildRadioOption('Live in', 'liveIn', controller),
              if (controller.locationOption.value == 'liveIn')
                Padding(
                  padding: EdgeInsets.only(left: 0.w, top: 12.h, bottom: 12.h),
                  child: LiveInOptions(controller: controller),
                ),
              SizedBox(height: 12.h),
              _buildRadioOption('Current Location', 'currentLocation', controller),
              if (controller.locationOption.value == 'currentLocation')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 36.w, top: 0.h),
                      child: Obx(() => Text(
                        controller.currentLocationAddress.value,
                        style: ConstantStyles.timerText,
                      )),
                    ),
                    DistanceSelector(controller: controller),
                  ],
                ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label, String value, FiltersController controller) {
    return Obx(() => GestureDetector(
      onTap: () {
        controller.setLocationOption(value);
      },
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.locationOption.value == value ? Color(0xFF20E2D7) : Colors.transparent,
              border: Border.all(
                color: controller.locationOption.value == value ? Color(0xFF20E2D7) : Colors.black,
                width: 2.w,
              ),
            ),
            child: controller.locationOption.value == value
                ? Icon(Icons.check, size: 16.w, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12.w),
          Text(label, style: ConstantStyles.genderWarningStyle),
        ],
      ),
    ));
  }
}


