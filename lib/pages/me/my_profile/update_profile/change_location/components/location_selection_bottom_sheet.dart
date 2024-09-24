import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../constants/Constant_styles.dart';

class LocationSelectionBottomSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String) onItemSelected;

  const LocationSelectionBottomSheet({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              title,
              style: ConstantStyles.selectLocationStyle,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.h,
                color: Colors.grey[300],
              ),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    items[index],
                    style: ConstantStyles.locationListStyle,
                  ),
                  onTap: () {
                    onItemSelected(items[index]);
                    Get.back();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
