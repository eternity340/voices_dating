import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../filters_controller.dart';

class AgeFilter extends StatelessWidget {
  final FiltersController controller;

  const AgeFilter({Key? key, required this.controller}) : super(key: key);

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
          Text(ConstantData.ageHead, style: ConstantStyles.locationListStyle),
          SizedBox(height: 16.h),
          Obx(() => RangeSlider(
            values: RangeValues(
                double.parse(controller.minAge.value),
                double.parse(controller.maxAge.value)
            ),
            min: 19,
            max: 99,
            divisions: 80,
            labels: RangeLabels(controller.minAge.value, controller.maxAge.value),
            activeColor: Color(0xFF20E2D7),
            inactiveColor: Color(0xFF20E2D7).withOpacity(0.3),
            onChanged: (RangeValues values) {
              controller.minAge.value = values.start.round().toString();
              controller.maxAge.value = values.end.round().toString();
            },
          )),
          SizedBox(height: 10.h),
          Obx(() => Text(
            'Selected age range: ${controller.minAge.value} - ${controller.maxAge.value}',
            style: ConstantStyles.verifySuccessSubtitle,
          )),
        ],
      ),
    );
  }
}
