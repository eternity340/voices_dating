import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:voices_dating/constants/constant_data.dart';

class MultiSelectBottomSheet extends StatelessWidget {
  final int number;
  final List<String> options;
  final List<String> initialSelection;
  final Function(List<String>) onConfirm;
  final bool allowEmptySelection;
  final bool isSingleSelect; // 新增参数

  MultiSelectBottomSheet({
    required this.number,
    required this.options,
    required this.initialSelection,
    required this.onConfirm,
    this.allowEmptySelection = false,
    this.isSingleSelect = false, // 默认为多选
  }) : assert(number == options.length);

  final selectedOptions = RxList<String>([]);

  @override
  Widget build(BuildContext context) {
    selectedOptions.value = List.from(initialSelection);

    return Container(
      height: (number * 56 + 150).h,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(ConstantData.cancelText, style: ConstantStyles.welcomeButtonStyle),
                ),
                Text(ConstantData.lookingForText.toUpperCase(), style: ConstantStyles.middleTextStyle),
                TextButton(
                  onPressed: () {
                    if (allowEmptySelection || selectedOptions.isNotEmpty) {
                      onConfirm(selectedOptions);
                      Get.back();
                    } else {
                      Get.snackbar('Warning', 'You must select at least one option');
                    }
                  },
                  child: Text('Done', style: ConstantStyles.welcomeButtonStyle),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Text(
              isSingleSelect ? 'Select one option' : ConstantData.multipleChoicesText,
              style: ConstantStyles.feedbackHintStyle,
            ),
          ),
          ...List.generate(number, (index) {
            return ListTile(
              title: Text(options[index], style: ConstantStyles.welcomeButtonStyle),
              trailing: Obx(() => isSingleSelect
                  ? Radio<String>(
                value: (index + 1).toString(),
                groupValue: selectedOptions.isNotEmpty ? selectedOptions.first : null,
                onChanged: (_) => toggleOption((index + 1).toString()),
                activeColor: Color(0xFF20E2D7),
              )
                  : Checkbox(
                value: selectedOptions.contains((index + 1).toString()),
                onChanged: (_) => toggleOption((index + 1).toString()),
                activeColor: Color(0xFF20E2D7),
              )),
              onTap: () => toggleOption((index + 1).toString()),
            );
          }),
        ],
      ),
    );
  }

  void toggleOption(String option) {
    if (isSingleSelect) {
      selectedOptions.clear();
      selectedOptions.add(option);
    } else {
      if (selectedOptions.contains(option)) {
        if (allowEmptySelection || selectedOptions.length > 1) {
          selectedOptions.remove(option);
        }
      } else {
        selectedOptions.add(option);
      }
    }
  }
}
