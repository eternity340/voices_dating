import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../me/my_profile/update_profile/change_location/components/location_selection_bottom_sheet.dart';
import '../../filters_controller.dart';

class LiveInOptions extends StatelessWidget {
  final FiltersController controller;

  const LiveInOptions({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationBox(ConstantData.countryText, context),
        SizedBox(height: 8.h),
        _buildLocationBox(ConstantData.stateText, context),
        SizedBox(height: 8.h),
        _buildLocationBox(ConstantData.cityText, context),
      ],
    );
  }

  Widget _buildLocationBox(String type, BuildContext context) {
    return Obx(() {
      String text = _getText(type);
      bool isEnabled = _isEnabled(type);

      return GestureDetector(
        onTap: isEnabled ? () => _showLocationSelection(context, type) : null,
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    text,
                    style: ConstantStyles.timerText,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (type == ConstantData.cityText && controller.isCityLoading.value)
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                    ),
                  )
                else
                  Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _getText(String type) {
    switch (type) {
      case ConstantData.countryText:
        return controller.selectedCountry.value;
      case ConstantData.stateText:
        return controller.selectedState.value;
      case ConstantData.cityText:
        return controller.selectedCity.value;
      default:
        return '';
    }
  }

  bool _isEnabled(String type) {
    return type == ConstantData.countryText
        || (type == ConstantData.stateText
            && controller.selectedCountry.value
            != ConstantData.selectedCountry)
        || (type == ConstantData.cityText
            && controller.selectedState.value
            != ConstantData.selectedState
            && controller.selectedState.value
            != 'All states'
            && !controller.isCityLoading.value);
  }

  void _showLocationSelection(BuildContext context, String type) async {
    List<String> items = await controller.getItemsByType(type);

    if (type == ConstantData.stateText) {
      items.insert(0, 'All states');
    }

    Get.bottomSheet(
      LocationSelectionBottomSheet(
        title: 'Select ${type.capitalize}',
        items: items,
        onItemSelected: (selectedItem) {
          controller.updateLiveInLocation(type, selectedItem);
          if (type == ConstantData.stateText && selectedItem == 'All states') {
            controller.selectedCity.value = ConstantData.selectedCity;
          }
        },
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}