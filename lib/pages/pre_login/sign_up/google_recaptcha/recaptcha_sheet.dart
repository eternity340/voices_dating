import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../image_res/image_res.dart';
import '../../sign_in/components/common_button.dart';
import 'custom_recaptcha_widget.dart';

void showRecaptcha(
  BuildContext context,
  String apiKey,
  void Function(String token) handler,
) {
  bool validating = false;
  Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setState) {
        return Container(
          constraints: BoxConstraints(
              minHeight: 90,
              maxHeight: MediaQuery.of(context).size.height / 1.5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white),
          padding: const EdgeInsets.only(top: 18, bottom: 30),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageRes.imagePathBackButton,
                    width: 34.w,
                    height: 34.h,
                  ),
                  Container(
                    width: 15.w,
                  ),
                  Text(
                    "Are You A Robot?",
                    style: TextStyle(fontSize: 24.sp),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 18, left: 15, right: 15),
                height: 1.h,
                // color: const Color(0xffD7D7DB).withAlpha(100),
                color: const Color(0xffD7D7DB),
              ),
              validating
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomRecaptchaWidget(
                          apiKey: apiKey,
                          tokenHandler: (value) {
                            Get.back();
                            handler.call(value);
                          },
                        ),
                      ],
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: commonButton(
                        textSize: 18.sp,
                        callBack: () {
                          setState(() {
                            validating = true;
                          });
                        },
                        buttonTitle: "I am not a robot",
                      ),
                    )
            ],
          ),
        );
      },
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: false,
    isDismissible: true,
    enableDrag: false,
  );
}
