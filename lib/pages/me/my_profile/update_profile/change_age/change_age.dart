import 'package:first_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:first_app/entity/token_entity.dart';
import 'package:first_app/entity/user_data_entity.dart';

import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../pre_login/sign_up/components/widget/picker_components.dart';
import 'change_age_controller.dart';

class ChangeAge extends StatelessWidget {
  final ChangeAgeController controller = Get.put(ChangeAgeController());

  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['token'] as TokenEntity;
    final userData = Get.arguments['userData'] as UserDataEntity;

    double pickerWidth = 80.w;
    double pickerHeight = 280.h;
    double itemExtent = 40.h;

    return Scaffold(
      body: Background(
        showMiddleText: true,
        middleText: ConstantData.ageHead,
        showActionButton: false,
        showBackgroundImage: false,
        child: Stack(
          children: [
            Positioned(
              top: 100.h,
              left: 0,
              right: 0,
              child: buildPickers(
                context: context,
                pickerWidth: pickerWidth,
                pickerHeight: pickerHeight,
                itemExtent: itemExtent,
                dayController: controller.dayController,
                monthController: controller.monthController,
                yearController: controller.yearController,
                selectedDay: controller.selectedDay.value,
                selectedMonth: controller.selectedMonth.value,
                selectedYear: controller.selectedYear.value,
                onDayChanged: (index) {
                  controller.selectedDay.value = index + 1;
                },
                onMonthChanged: (index) {
                  controller.selectedMonth.value = index + 1;
                },
                onYearChanged: (index) {
                  controller.selectedYear.value = DateTime.now().year - index;
                },
              ),
            ),
            Positioned(
              top: 0.h,
              right: 0.w,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(-8.w, 0, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
                  ),
                  borderRadius: BorderRadius.circular(24.5.r),
                ),
                width: 88.w,
                height: 36.h,
                child: TextButton(
                  onPressed: () => controller.updateProfile(tokenEntity, userData),
                  child: Text(
                      ConstantData.saveText,
                      style: ConstantStyles.saveButtonTextStyle
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
