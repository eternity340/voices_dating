import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void showCommonActionDialog(
    {required Function(String source) callback,
      bool isNeedGetBack = true,
      selectItemCount = 2,
      List<String> selectItemTitle = const [
        "Take a photo",
        "Choose from library"
      ]}) {
  Get.bottomSheet(Container(
    padding: EdgeInsets.only(bottom: 16.h),
    height:Get.height, // 设置高度为屏幕高度的一半
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(26.sp), topLeft: Radius.circular(26.sp))),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(selectItemCount + 1, (index) {
        if (index == selectItemCount) {
          return GestureDetector(
            onTap: () {
              Get.until((route) => Get.isBottomSheetOpen == false);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 19.h),
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(218, 218, 218, 1),
                      ))),
              width: 1.sw - 32.w,
              alignment: Alignment.center,
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontSize: 18.sp, color: Colors.black, wordSpacing: 0.64.w),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () {
              callback.call(index.toString());
              isNeedGetBack
                  ? Get.until((route) => Get.isBottomSheetOpen == false)
                  : null;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 19.h),
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(218, 218, 218, 1),
                      ))),
              width: 1.sw - 32.w,
              alignment: Alignment.center,
              child: Text(
                selectItemTitle[index],
                style: TextStyle(
                    fontSize: 18.sp, color: Colors.black, wordSpacing: 0.64.w),
              ),
            ),
          );
        }
      }),
    ),
  ));
}