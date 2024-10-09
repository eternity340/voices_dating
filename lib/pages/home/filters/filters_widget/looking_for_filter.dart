import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../filters_controller.dart';
import '../components/multi_select_bottom_sheet.dart';

class LookingForFilter extends StatelessWidget {
  final FiltersController controller;

  const LookingForFilter({Key? key, required this.controller}) : super(key: key);

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
          Text(ConstantData.lookingForText, style: ConstantStyles.locationListStyle),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                MultiSelectBottomSheet(
                  number: 2,
                  options: ['Men', 'Women'],
                  initialSelection: controller.selectedLookingFor,
                  onConfirm: (selected) {
                    controller.updateSelectedLookingFor(selected);
                  },
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    controller.getLookingForText(),
                    style: ConstantStyles.buttonLabelStyle,
                  )),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}