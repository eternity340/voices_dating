import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';
import 'components/widget/picker_components.dart';

class SelectBirthdayPage extends StatefulWidget {
  final User user;

  SelectBirthdayPage({required this.user});

  @override
  _SelectBirthdayPageState createState() => _SelectBirthdayPageState();
}

class _SelectBirthdayPageState extends State<SelectBirthdayPage> {
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
    double pickerWidth = 120.0; // Width of each picker
    double pickerHeight = 280.0; // Height of each picker
    double itemExtent = 40.0; // Height of each item

    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                _buildTitle(),
                SizedBox(height: 20),
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
                SizedBox(height: 200),
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Birthday",
      style: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContinueButton() {
    return GradientButton(
      text: "Continue",
      onPressed: () {
        DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
        widget.user.birthday = selectedDate;

        // Calculate age
        int age = DateTime.now().year - selectedYear;
        if (DateTime.now().month < selectedMonth ||
            (DateTime.now().month == selectedMonth && DateTime.now().day < selectedDay)) {
          age--;
        }
        widget.user.age = age;

        Get.toNamed('/select_height', arguments: widget.user);
      },
    );
  }
}
