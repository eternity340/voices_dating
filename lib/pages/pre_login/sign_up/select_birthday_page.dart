import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';
import 'components/widget/picker_components.dart';
import '../../../constants/constant_data.dart';
import '../../../constants/constant_styles.dart';

class SelectBirthdayPage extends StatefulWidget {
  final User user;

  SelectBirthdayPage({required this.user});

  @override
  _SelectBirthdayPageState createState() => _SelectBirthdayPageState();
}

class _SelectBirthdayPageState extends State<SelectBirthdayPage> {
  FixedExtentScrollController _dayController = FixedExtentScrollController();
  FixedExtentScrollController _monthController = FixedExtentScrollController();
  FixedExtentScrollController _yearController = FixedExtentScrollController();

  int selectedDay = 1;
  int selectedMonth = 1;
  int selectedYear = DateTime.now().year;
  bool isOver18 = false;

  @override
  void initState() {
    super.initState();
    _dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    _monthController = FixedExtentScrollController(initialItem: selectedMonth - 1);
    _yearController = FixedExtentScrollController(initialItem: DateTime.now().year - selectedYear);
    _checkAge();
  }

  void _checkAge() {
    DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    DateTime today = DateTime.now();
    Duration difference = today.difference(selectedDate);
    int age = (difference.inDays / 365).floor();
    setState(() {
      isOver18 = age >= 18;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 20.0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                _buildTitle(),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: buildPickers(
                    context: context,
                    pickerWidth: 100.0.w,
                    pickerHeight: 280.0.h,
                    itemExtent: 40.0.h,
                    dayController: _dayController,
                    monthController: _monthController,
                    yearController: _yearController,
                    selectedDay: selectedDay,
                    selectedMonth: selectedMonth,
                    selectedYear: selectedYear,
                    onDayChanged: (index) {
                      setState(() {
                        selectedDay = index + 1;
                        _checkAge();
                      });
                    },
                    onMonthChanged: (index) {
                      setState(() {
                        selectedMonth = index + 1;
                        _checkAge();
                      });
                    },
                    onYearChanged: (index) {
                      setState(() {
                        selectedYear = DateTime.now().year - index;
                        _checkAge();
                      });
                    },
                  ),
                ),
                SizedBox(height: 150.h),
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      ConstantData.birthdayTitle,
      style: ConstantStyles.birthdayTitleStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContinueButton() {
    return GradientButton(
      text: ConstantData.continueButtonText,
      onPressed: isOver18 ? () {
        String formattedDate = "${selectedYear.toString().padLeft(4, '0')}/${selectedMonth.toString().padLeft(2, '0')}/${selectedDay.toString().padLeft(2, '0')}";
        widget.user.birthday = formattedDate;

        DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
        int age = DateTime.now().year - selectedYear;
        if (DateTime.now().month < selectedMonth ||
            (DateTime.now().month == selectedMonth && DateTime.now().day < selectedDay)) {
          age--;
        }
        widget.user.age = age;

        Get.toNamed('/select_height', arguments: widget.user);
      } : null,
      isDisabled: !isOver18,
    );
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
