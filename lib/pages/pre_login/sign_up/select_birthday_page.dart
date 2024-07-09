import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';

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
  int selectedYear = DateTime
      .now()
      .year;

  @override
  void initState() {
    super.initState();
    // Set initial scroll positions
    _dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    _monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    _yearController = FixedExtentScrollController(initialItem: DateTime
        .now()
        .year - selectedYear);
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
                _buildPickers(context, pickerWidth, pickerHeight, itemExtent),
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

  Widget _buildPickers(BuildContext context, double pickerWidth,
      double pickerHeight, double itemExtent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent, width: 0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPicker(
                controller: _dayController,
                itemCount: 31,
                itemExtent: itemExtent,
                selectedIndex: selectedDay - 1,
                labelBuilder: (index) => '${index + 1}D',
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedDay = index + 1;
                  });
                },
                pickerWidth: pickerWidth,
                pickerHeight: pickerHeight,
              ),
              _buildPicker(
                controller: _monthController,
                itemCount: 12,
                itemExtent: itemExtent,
                selectedIndex: selectedMonth - 1,
                labelBuilder: (index) => '${index + 1}M',
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedMonth = index + 1;
                  });
                },
                pickerWidth: pickerWidth,
                pickerHeight: pickerHeight,
              ),
              _buildPicker(
                controller: _yearController,
                itemCount: 100,
                itemExtent: itemExtent,
                selectedIndex: DateTime
                    .now()
                    .year - selectedYear,
                labelBuilder: (index) => '${DateTime
                    .now()
                    .year - index}',
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedYear = DateTime
                        .now()
                        .year - index;
                  });
                },
                pickerWidth: pickerWidth,
                pickerHeight: pickerHeight,
              ),
            ],
          ),
        ),
        _buildHighlight(pickerHeight, itemExtent),
      ],
    );
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required double itemExtent,
    required int selectedIndex,
    required String Function(int) labelBuilder,
    required Function(int) onSelectedItemChanged,
    required double pickerWidth,
    required double pickerHeight,
  }) {
    return Container(
      height: pickerHeight,
      width: pickerWidth,
      child: ListWheelScrollView(
        controller: controller,
        itemExtent: itemExtent,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        children: List.generate(itemCount, (index) {
          return Container(
            height: itemExtent,
            alignment: Alignment.center,
            child: Text(
              labelBuilder(index),
              style: TextStyle(
                fontSize: selectedIndex == index ? 24.0 : 20.0,
                color: selectedIndex == index ? Colors.black : Color(
                    0xFFB0B0B0),
                fontFamily: 'Poppins',
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHighlight(double pickerHeight, double itemExtent) {
    return Positioned(
      top: pickerHeight / 2 - itemExtent / 2,
      left: 16, // Add some padding to align with the pickers
      right: 16,
      child: Container(
        height: itemExtent,
        decoration: BoxDecoration(
          color: Color(0xFFABFFCF).withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return GradientButton(
      text: "Continue",
      onPressed: () {
        DateTime selectedDate = DateTime(
            selectedYear, selectedMonth, selectedDay);
        widget.user.birthday = selectedDate;

        // Calculate age
        int age = DateTime
            .now()
            .year - selectedYear;
        if (DateTime
            .now()
            .month < selectedMonth ||
            (DateTime
                .now()
                .month == selectedMonth && DateTime
                .now()
                .day < selectedDay)) {
          age--;
        }
        widget.user.age = age;

        Get.toNamed('/select_height', arguments: widget.user);
      },
    );
  }
}

class VariableScrollPhysics extends FixedExtentScrollPhysics {
  final double itemExtent;

  const VariableScrollPhysics({required this.itemExtent, ScrollPhysics? parent}) : super(parent: parent);

  @override
  VariableScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return VariableScrollPhysics(itemExtent: itemExtent, parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final targetPixels = position.pixels + velocity * 0.5; // Adjust the multiplier for faster scrolling
    final targetItem = (targetPixels / itemExtent).round();
    return ScrollSpringSimulation(
      spring,
      position.pixels,
      targetItem * itemExtent,
      velocity,
      tolerance: tolerance,
    );
  }
}
