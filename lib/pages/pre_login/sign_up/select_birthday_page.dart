import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../components/gradient_btn.dart';
import '../../../components/background.dart';

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
                SizedBox(height: 50),
                const Text(
                  "Birthday",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Poppins'), // Use appropriate font family here
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Container for day, month, and year pickers
                Stack(
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
                          // Day picker
                          Container(
                            height: pickerHeight,
                            width: pickerWidth,
                            child: ListWheelScrollView(
                              controller: _dayController,
                              itemExtent: itemExtent,
                              physics: VariableScrollPhysics(itemExtent: itemExtent),
                              children: List.generate(31, (index) {
                                return Container(
                                  height: itemExtent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}D',
                                    style: TextStyle(
                                      fontSize: selectedDay == index + 1 ? 24.0 : 20.0,
                                      color: selectedDay == index + 1 ? Colors.black : Color(0xFFB0B0B0),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                );
                              }),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedDay = index + 1;
                                });
                              },
                            ),
                          ),
                          // Month picker
                          Container(
                            height: pickerHeight,
                            width: pickerWidth,
                            child: ListWheelScrollView(
                              controller: _monthController,
                              itemExtent: itemExtent,
                              physics: VariableScrollPhysics(itemExtent: itemExtent),
                              children: List.generate(12, (index) {
                                return Container(
                                  height: itemExtent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}M',
                                    style: TextStyle(
                                      fontSize: selectedMonth == index + 1 ? 24.0 : 20.0,
                                      color: selectedMonth == index + 1 ? Colors.black : Color(0xFFB0B0B0),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                );
                              }),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedMonth = index + 1;
                                });
                              },
                            ),
                          ),
                          // Year picker
                          Container(
                            height: pickerHeight,
                            width: pickerWidth,
                            child: ListWheelScrollView(
                              controller: _yearController,
                              itemExtent: itemExtent,
                              physics: VariableScrollPhysics(itemExtent: itemExtent),
                              children: List.generate(100, (index) {
                                int year = DateTime.now().year - index;
                                return Container(
                                  height: itemExtent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$year',
                                    style: TextStyle(
                                      fontSize: selectedYear == year ? 24.0 : 20.0,
                                      color: selectedYear == year ? Colors.black : Color(0xFFB0B0B0),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                );
                              }),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedYear = DateTime.now().year - index;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Highlight the selected item
                    Positioned(
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
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Continue button
                GradientButton(
                  text: "Continue",
                  onPressed: () {
                    DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                    widget.user.birthday = selectedDate;
                    Get.toNamed('/profile_summary', arguments: widget.user);
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
