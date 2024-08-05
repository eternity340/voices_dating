import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:first_app/components/background.dart';
import 'package:first_app/entity/token_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../components/bottom_options.dart';
import '../../../components/custom_message_dialog.dart';
import '../../../components/gradient_btn.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/user_data_entity.dart';
import '../../../image_res/image_res.dart';

class AddMomentPage extends StatefulWidget {
  @override
  _AddMomentPageState createState() => _AddMomentPageState();
}

class _AddMomentPageState extends State<AddMomentPage> {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;
  List<XFile?> _imageFiles = [null]; // 初始化时包含一个null图片的列表
  TextEditingController _textEditingController = TextEditingController();

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
          Positioned(
            top: 100.h,
            left: 20.w,
            child: Container(
              width: 335.0.w,
              height: 200.0.h,
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _textEditingController,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  hintText: 'record the moment ...',
                  hintStyle: TextStyle(
                    color: Colors.grey, // 可以根据需要更改提示文字的颜色
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                  ),
                ),
                onChanged: (text) {
                  // Handle text changes
                },
              ),
            ),
          ),
          Positioned(
            top: 302.h,
            left: 20.w,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ConstantData.colorTopicsHintText,
                  style: ConstantStyles.smallTextStyle,
                ),
                SizedBox(width: 180),
              ],
            ),
          ),
          Positioned(
            left: 20.w,
            top: 326.h,
            child: Container(
              width: 335.w,
              height: 345.h,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 每行两个项目
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1.0,
                ),
                itemCount: _imageFiles.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () {
                      _showBottomOptions(context, index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F8F9),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: _imageFiles[index] == null
                          ? Center(
                        child: Image.asset(
                          ImageRes.imagePathIconAddPhoto,
                          width: 24.w,
                          height: 24.h,
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.file(
                          File(_imageFiles[index]!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 700.h, // 根据总内容高度调整
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: ConstantData.uploadText,
                onPressed: _uploadMoment,
                height: 49.h,
                width: 248.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return BottomOptions(
          onFirstPressed: () async {
            Navigator.pop(context);
            await _handleCameraPermission(index);
          },
          onSecondPressed: () async {
            Navigator.pop(context);
            await _handleStoragePermission(index);
          },
          onCancelPressed: () {
            Navigator.pop(context);
          },
          firstText: ConstantData.takePhotoText,
          secondText: ConstantData.fromAlbumText,
        );
      },
    );
  }

  Future<void> _handleCameraPermission(int index) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          if (index == _imageFiles.length - 1) {
            _imageFiles[index] = pickedFile;
            _imageFiles.add(null); // 添加一个新的空条目用于下一个添加照片按钮
          } else {
            _imageFiles[index] = pickedFile;
          }
        });
      }
    } else {
      // Handle permission denied
    }
  }

  Future<void> _handleStoragePermission(int index) async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (index == _imageFiles.length - 1) {
            _imageFiles[index] = pickedFile;
            _imageFiles.add(null); // 添加一个新的空条目用于下一个添加照片按钮
          } else {
            _imageFiles[index] = pickedFile;
          }
        });
      }
    } else {
      // Handle permission denied
    }
  }

  Future<void> _uploadMoment() async {
    final content = _textEditingController.text;
    final formData = dio.FormData();
    formData.fields.add(MapEntry('content', content));
    for (var imageFile in _imageFiles) {
      if (imageFile != null) {
        final file = await dio.MultipartFile.fromFile(imageFile.path, filename: imageFile.name);
        formData.files.add(MapEntry('file', file));
      }
    }

    try {
      final response = await dio.Dio().post(
        'https://api.masonvips.com/v1/upload_timeline',
        data: formData,
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        Get.snackbar('Error', 'Failed to upload moment');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while uploading the moment');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomMessageDialog(
          title: Text('Success'),
          content: Text('Moment uploaded successfully!'),
          onYesPressed: () {
            Get.offAllNamed('/moments', arguments: {'token': tokenEntity, 'userData': userData}); // 跳转到 Moments 界面
          },
        );
      },
    );
  }
}
