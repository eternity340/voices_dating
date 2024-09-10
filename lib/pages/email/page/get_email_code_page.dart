import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../constants/constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../utils/common_utils.dart';
import '../controller/get_email_code_controller.dart';

class GetMailCodePage extends GetView<GetEmailCodeController> {
  GetMailCodePage() {
    Get.lazyPut<GetEmailCodeController>(() => GetEmailCodeController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: Text(
                    ConstantData.welcomeText,
                    textAlign: TextAlign.center,
                    style: ConstantStyles.welcomeTextStyle,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    ConstantData.enterEmailText,
                    textAlign: TextAlign.start,
                    style: ConstantStyles.enterEmailTextStyle,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Obx(() => TextField(
                        controller: controller.emailController,
                        focusNode: controller.emailFocusNode,
                        decoration: InputDecoration(
                          labelText: ConstantData.emailLabelText,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorText: controller.errorMessage.value.isNotEmpty
                              ? controller.errorMessage.value
                              : null,
                          filled: true,
                          fillColor: Colors.transparent,
                          labelStyle: TextStyle(
                            color: controller.isEmailFocused.value
                                ? Color(0xFF20E2D7)
                                : Colors.black,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: controller.isEmailFocused.value
                                ? Color(0xFF20E2D7)
                                : Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Color(0xFF20E2D7),
                      )),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Obx(() => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedDomain.value,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              style: ConstantStyles.pathBoxTextStyle,
                              items: controller.emailDomains.map((String domain) {
                                return DropdownMenuItem<String>(
                                  value: domain,
                                  child: Text(domain),
                                );
                              }).toList(),
                              onChanged: controller.onDomainChanged,
                            ),
                          )),
                          Obx(() => controller.isCustomDomain.value
                              ? Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: TextField(
                              controller: controller.customDomainController,
                              decoration: InputDecoration(
                                hintText: 'your email domain',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: ConstantStyles.pathBoxTextStyle,
                            ),
                          )
                              : SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 300.h),
                Obx(() => controller.isLoading.value
                    ? CommonUtils.loadingIndicator(
                  color: Colors.black,
                  radius: 15.0,
                )
                    : Center(
                  child: GradientButton(
                    text: ConstantData.nextButtonText,
                    onPressed: () => controller.sendVerificationCode(),
                    width: 200.w,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
