import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constant_data.dart';

class PhotoDialog extends StatefulWidget {
  final String photoUrl;
  final String attachId;
  final VoidCallback? onDelete;
  final VoidCallback? onSetting;
  final bool showSettings;

  const PhotoDialog({
    Key? key,
    required this.photoUrl,
    required this.attachId,
    required this.onDelete,
    required this.onSetting,
    this.showSettings = true,
  }) : super(key: key);

  @override
  State<PhotoDialog> createState() => _PhotoDialogState();
}

class _PhotoDialogState extends State<PhotoDialog> {
  // For zooming functionality
  double _scale = 1.0;
  double _previousScale = 1.0;

  void _onScaleStart(ScaleStartDetails details) {
    _previousScale = _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = _previousScale * details.scale;
    });
  }

  void onSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ConstantData.confirmText),
          content: Text(ConstantData.changeMainPhotoText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(ConstantData.noText),
            ),
            TextButton(
              onPressed: widget.onSetting,
              child: Text(ConstantData.yesText),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  width: 335.w,
                  height: 470.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(1),
                        spreadRadius: 6.w,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.r),
                    child: Image.network(
                      widget.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 90.h,
            left: 10.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4.r,
                    spreadRadius: 1.w,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          if (widget.showSettings)
            Positioned(
              top: 640.h,
              right: 10.w,
              child: Container(
                width: 100.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4.r,
                      spreadRadius: 1.w,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: widget.onSetting,
                      icon: Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
