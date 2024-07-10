import 'package:flutter/material.dart';

Widget buildPickers({
  required BuildContext context,
  required double pickerWidth,
  required double pickerHeight,
  required double itemExtent,
  required FixedExtentScrollController dayController,
  required FixedExtentScrollController monthController,
  required FixedExtentScrollController yearController,
  required int selectedDay,
  required int selectedMonth,
  required int selectedYear,
  required ValueChanged<int> onDayChanged,
  required ValueChanged<int> onMonthChanged,
  required ValueChanged<int> onYearChanged,
}) {
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
            buildPicker(
              controller: dayController,
              itemCount: 31,
              itemExtent: itemExtent,
              selectedIndex: selectedDay - 1,
              labelBuilder: (index) => '${index + 1}D',
              onSelectedItemChanged: onDayChanged,
              pickerWidth: pickerWidth,
              pickerHeight: pickerHeight,
            ),
            buildPicker(
              controller: monthController,
              itemCount: 12,
              itemExtent: itemExtent,
              selectedIndex: selectedMonth - 1,
              labelBuilder: (index) => '${index + 1}M',
              onSelectedItemChanged: onMonthChanged,
              pickerWidth: pickerWidth,
              pickerHeight: pickerHeight,
            ),
            buildPicker(
              controller: yearController,
              itemCount: 100,
              itemExtent: itemExtent,
              selectedIndex: DateTime.now().year - selectedYear,
              labelBuilder: (index) => '${DateTime.now().year - index}',
              onSelectedItemChanged: onYearChanged,
              pickerWidth: pickerWidth,
              pickerHeight: pickerHeight,
            ),
          ],
        ),
      ),
      buildHighlight(pickerHeight: pickerHeight, itemExtent: itemExtent),
    ],
  );
}

Widget buildPicker({
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
              color: selectedIndex == index ? Colors.black : Color(0xFFB0B0B0),
              fontFamily: 'Poppins',
            ),
          ),
        );
      }),
    ),
  );
}

Widget buildHighlight({required double pickerHeight, required double itemExtent}) {
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
