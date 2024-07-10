import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeightPicker extends StatefulWidget {
  final int initialHeight;
  final ValueChanged<int> onHeightChanged;

  HeightPicker({required this.initialHeight, required this.onHeightChanged});

  @override
  _HeightPickerState createState() => _HeightPickerState();

}

class _HeightPickerState extends State<HeightPicker> {
  late FixedExtentScrollController _heightController;

  @override
  void initState() {
    super.initState();
    // Set initial scroll position
    _heightController = FixedExtentScrollController(initialItem: widget.initialHeight - 100);
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

    return Stack(
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
                      fontSize: widget.initialHeight == reversedIndex + 100 ? 24.0 : 20.0,
                      color: widget.initialHeight == reversedIndex + 100 ? Colors.black : Color(0xFFB0B0B0),
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              }),
              onSelectedItemChanged: (index) {
                setState(() {
                  widget.onHeightChanged(250 - index); // Adjust the selected value
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