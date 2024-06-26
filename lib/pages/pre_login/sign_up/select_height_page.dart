import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../components/gradient_btn.dart';
import '../../../components/background.dart';

class SelectHeightPage extends StatefulWidget {
  final User user;

  SelectHeightPage({required this.user});

  @override
  _SelectHeightPageState createState() => _SelectHeightPageState();
}

class _SelectHeightPageState extends State<SelectHeightPage> {
  // Scroll controller for height picker
  FixedExtentScrollController _heightController = FixedExtentScrollController();

  // Current selected value
  int selectedHeight = 170; // Default height

  @override
  void initState() {
    super.initState();
    // Set initial scroll position
    _heightController = FixedExtentScrollController(initialItem: selectedHeight - 100);
  }

  @override
  void dispose() {
    // Dispose controller
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double pickerWidth = 120.0; // Width of the picker
    double pickerHeight = 280.0; // Height of the picker
    double itemExtent = 40.0; // Height of each item
    double highlightWidth = 335.0; // Width of the highlight container

    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                const Text(
                  "Height",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Poppins'), // Use appropriate font family here
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                // Container for height picker
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.transparent, width: 0),
                      ),
                      child: Container(
                        height: pickerHeight,
                        width: pickerWidth,
                        child: ListWheelScrollView(
                          controller: _heightController,
                          itemExtent: itemExtent,
                          physics: VariableScrollPhysics(itemExtent: itemExtent),
                          children: List.generate(151, (index) {
                            int reversedIndex = 150 - index; // Reverse the index
                            return Container(
                              height: itemExtent,
                              alignment: Alignment.center,
                              child: Text(
                                '${reversedIndex + 100}cm',
                                style: TextStyle(
                                  fontSize: selectedHeight == reversedIndex + 100 ? 24.0 : 20.0,
                                  color: selectedHeight == reversedIndex + 100 ? Colors.black : Color(0xFFB0B0B0),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            );
                          }),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedHeight = 250 - index; // Adjust the selected value
                            });
                          },
                        ),
                      ),
                    ),
                    // Highlight the selected item
                    Positioned(
                      top: pickerHeight / 2 - itemExtent / 2,
                      left: (pickerWidth - highlightWidth) / 2, // Center the highlight container horizontally
                      child: Container(
                        height: itemExtent,
                        width: highlightWidth,
                        decoration: BoxDecoration(
                          color: Color(0xFFABFFCF).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 170),
                // Continue button
                GradientButton(
                  text: "Continue",
                  onPressed: () {
                    widget.user.height = selectedHeight.toString();
                    Get.toNamed('/', arguments: widget.user);
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
