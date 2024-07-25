import 'dart:io';

import 'package:first_app/components/background.dart';
import 'package:first_app/entity/token_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../components/bottom_options.dart';
import '../../../components/gradient_btn.dart';

class AddMomentPage extends StatefulWidget {
  @override
  _AddMomentPageState createState() => _AddMomentPageState();
}

class _AddMomentPageState extends State<AddMomentPage> {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  List<XFile?> _imageFiles = [null]; // Initialize with one null image for the first add photo button

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
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                ),
                maxLines: null,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You can use #+ content to add color topics.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.0,
                    color: Colors.black,
                    letterSpacing: 0.02,
                  ),
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
                  crossAxisCount: 2, // Two items per row
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
                          'assets/images/icon_add_photo.png',
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
            top: 700.h, // Adjust based on the total content height
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: 'Upload',
                onPressed: () {
                  // Handle upload button press
                },
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
          firstText: 'Take a Photo',
          secondText: 'From Album',
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
            _imageFiles.add(null); // Add a new null entry for the next add photo button
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
            _imageFiles.add(null); // Add a new null entry for the next add photo button
          } else {
            _imageFiles[index] = pickedFile;
          }
        });
      }
    } else {
      // Handle permission denied
    }
  }
}
