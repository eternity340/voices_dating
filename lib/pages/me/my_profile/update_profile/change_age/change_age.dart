import 'package:dio/dio.dart';
import 'package:first_app/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../components/gradient_btn.dart';
import '../../../../pre_login/sign_up/components/widget/picker_components.dart';

class ChangeAge extends StatefulWidget {
  @override
  _ChangeAgeState createState() => _ChangeAgeState();
}

class _ChangeAgeState extends State<ChangeAge> {
  // Scroll controllers for day, month, and year pickers
  FixedExtentScrollController _dayController = FixedExtentScrollController();
  FixedExtentScrollController _monthController = FixedExtentScrollController();
  FixedExtentScrollController _yearController = FixedExtentScrollController();

  // Current selected values
  int selectedDay = 1;
  int selectedMonth = 1;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    // Set initial scroll positions
    _dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    _monthController = FixedExtentScrollController(initialItem: selectedMonth - 1);
    _yearController = FixedExtentScrollController(initialItem: DateTime.now().year - selectedYear);
  }

  @override
  void dispose() {
    // Dispose controllers
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

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
        middleText: '      Age',
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
                dayController: _dayController,
                monthController: _monthController,
                yearController: _yearController,
                selectedDay: selectedDay,
                selectedMonth: selectedMonth,
                selectedYear: selectedYear,
                onDayChanged: (index) {
                  setState(() {
                    selectedDay = index + 1;
                  });
                },
                onMonthChanged: (index) {
                  setState(() {
                    selectedMonth = index + 1;
                  });
                },
                onYearChanged: (index) {
                  setState(() {
                    selectedYear = DateTime.now().year - index;
                  });
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
                  onPressed: () => _updateProfile(tokenEntity, userData), // 调用更新生日方法
                  child: const Text(
                    'save',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }


  void _updateProfile(TokenEntity tokenEntity, UserDataEntity userData) async {
    try {
      // Calculate age based on selected year
      int currentYear = DateTime.now().year;
      int age = currentYear - selectedYear;

      // Format selected date
      String formattedDate = '$selectedYear-${selectedMonth.toString().padLeft(2, '0')}-${selectedDay.toString().padLeft(2, '0')}';

      // Send API request
      dio.Response response = await Dio().post(
        'https://api.masonvips.com/v1/update_profile',
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        queryParameters: {
          'user[birthday]': formattedDate,
          'user[age]': age.toString(),
        },
      );
      // Check response status
      if (response.data['code'] == 200) {
        userData.age = age.toString();
        Get.snackbar('Success', 'Profile updated successfully');
        await Future.delayed(Duration(seconds: 2)); // 等待2秒以显示弹框
        Get.toNamed('/me/my_profile', arguments: {'token': tokenEntity, 'userData': userData});
      } else {
        // Show error message
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      print('Exception caught: $e');
      Get.snackbar('Error', 'Failed to update profile');
    }
  }


}
