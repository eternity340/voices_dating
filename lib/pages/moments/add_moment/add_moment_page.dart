import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'add_moment_controller.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../constants/constant_data.dart';
import '../../../constants/constant_styles.dart';
import '../../../image_res/image_res.dart';

class AddMomentPage extends StatelessWidget {
  final AddMomentController controller = Get.put(AddMomentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: true,
            showBackgroundImage: false,
            showMiddleText: false,
            child: Container(),
          ),
          _buildContentTextField(),
          _buildColorTopicsHint(),
          _buildImageGrid(),
          _buildUploadButton(),
        ],
      ),
    );
  }

  Widget _buildContentTextField() {
    return Positioned(
      top: 100.h,
      left: 10.w,
      child: Container(
        width: 335.0.w,
        height: 200.0.h,
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          controller: controller.textEditingController,
          style: ConstantStyles.inputTextStyle,
          maxLines: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            hintText: ConstantData.recordTheMomentText,
            hintStyle: ConstantStyles.inputTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildColorTopicsHint() {
    return Positioned(
      top: 302.h,
      left: 10.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ConstantData.colorTopicsHintText,
            style: ConstantStyles.smallTextStyle,
          ),
          SizedBox(width: 180),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return Positioned(
      left: 10.w,
      top: 326.h,
      child: Container(
        width: 335.w,
        height: 345.h,
        child: Obx(() => GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.0,
          ),
          itemCount: controller.imageFiles.length < controller.maxImages
              ? controller.imageFiles.length + 1
              : controller.imageFiles.length,
          itemBuilder: (context, index) {
            if (index == controller.imageFiles.length && controller.imageFiles.length < controller.maxImages) {
              return InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () => controller.showBottomOptions(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Image.asset(
                      ImageRes.imagePathIconAddPhoto,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                ),
              );
            } else {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      File(controller.imageFiles[index].path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () => controller.removeImageFile(index),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        )),
      ),
    );
  }

  Widget _buildUploadButton() {
    return Positioned(
      top: 700.h,
      left: 0,
      right: 0,
      child: Center(
        child: GradientButton(
          text: ConstantData.uploadText,
          onPressed: controller.uploadMoment,
          height: 49.h,
          width: 248.w,
        ),
      ),
    );
  }
}
