import 'package:first_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    double pickerWidth = 120.0; // Width of each picker
    double pickerHeight = 280.0; // Height of each picker
    double itemExtent = 40.0; // Height of each item

    return Scaffold(
      body: Background(
        showMiddleText: true,
        middleText: ConstantData.ageHead,
        showActionButton: false,
        showBackgroundImage: false,
        child: Stack(
          children: [
            Positioned(
              top: 100.0,
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
              top: 4.0, // 留出顶部间距
              right: 16.0, // 添加右侧间距，根据需要调整位置
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(-8, 0, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
                  ),
                  borderRadius: BorderRadius.circular(24.5),
                ),
                width: 88, // 调整按钮宽度适应文本
                height: 36,
                child: TextButton(
                  onPressed: () => controller.updateProfile(tokenEntity, userData), // 调用更新生日方法
                  child:  Text(
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
