import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../components/multi_select_bottom_sheet.dart';
import '../../../../../constants/Constant_styles.dart';

class TopicSubjectBottomSheet extends StatelessWidget {
  final String label;
  final List<String> topicOptions;
  final String placeholder;
  final Function(String) onTopicSelected; // 新增的回调函数

  TopicSubjectBottomSheet({
    Key? key,
    required this.label,
    required this.topicOptions,
    this.placeholder = 'Select Topic / Subject',
    required this.onTopicSelected, // 新增的回调函数
  }) : super(key: key);

  final selectedOption = RxString('');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ConstantStyles.signEmailTextStyle,
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return MultiSelectBottomSheet(
                  number: topicOptions.length,
                  options: topicOptions,
                  initialSelection: selectedOption.value.isEmpty ? [] : [selectedOption.value],
                  onConfirm: (List<String> selected) {
                    if (selected.isNotEmpty) {
                      selectedOption.value = selected.first;
                      onTopicSelected(selected.first); // 调用回调函数
                    }
                  },
                  isSingleSelect: true,
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFEBEBEB),
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() => Text(
                      selectedOption.value.isEmpty ? placeholder : selectedOption.value,
                      style: ConstantStyles.inputTextStyle,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
