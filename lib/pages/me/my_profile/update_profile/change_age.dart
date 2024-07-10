import 'package:first_app/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../components/gradient_btn.dart';
import '../../../pre_login/sign_up/components/widget/picker_components.dart';

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
        middleText: '     Age',
        showActionButton: true,
        showBackgroundImage: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 100),
                buildPickers(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

}
