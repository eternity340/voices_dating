import 'dart:convert';

import 'package:first_app/components/background.dart';
import 'package:first_app/components/gradient_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../verify_page.dart';

class VerifyPhotoPage extends StatefulWidget {
  @override
  _VerifyPhotoPageState createState() => _VerifyPhotoPageState();
}

class _VerifyPhotoPageState extends State<VerifyPhotoPage> {
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final dioInstance = dio.Dio();
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(_image!.path),
      'photoType': 3,
      'maskInfo': 'mask information,json format',
    });

    try {
      final response = await dioInstance.post(
        'https://api.masonvips.com/v1/upload_picture',
        data: formData,
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.data['code'] == 200) {
        Get.snackbar(
          'Success',
          'Upload successful',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.data['code'] == 30002000) {
        Get.snackbar(
          'Verify Photo does not match ',
          response.data['message'],
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
          snackStyle: SnackStyle.FLOATING,
          margin: EdgeInsets.all(10),
          borderRadius: 8,
          duration: Duration(seconds: 10),
          messageText: Text(
            response.data['message'],
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.sp,
            ),
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackgroundImage: false,
            showMiddleText: true,
            showBackButton: true,
            middleText: 'Verify Photo',
            child: Container(),
          ),
          Positioned(
            top: 95.h,
            left: (ScreenUtil().screenWidth - 335.w) / 2,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 335.w,
                height: 351.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: _image == null
                    ? Center(
                  child: Image.asset(
                    'assets/images/icon_pic.png',
                    width: 48.w,
                    height: 48.h,
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 462.h,
            left: 16.w,
            right: 16.w,
            child: Text(
              'Please upload a live photo and we will analyze whether your photo is yourself.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 572.h,
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: 'Upload',
                onPressed: _uploadImage,
                height: 49.h,
                width: 248.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
