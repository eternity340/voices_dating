import 'dart:io';

import 'package:camera/camera.dart';
import 'package:common_utils/common_utils.dart';
import 'package:voices_dating/components/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../service/global_service.dart';
import 'components/Circle_painter.dart';

class VerifyVideoPage extends StatefulWidget {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity']as TokenEntity;
  final UserDataEntity userData = Get.arguments['userDataEntity'] as UserDataEntity;
  final GlobalService _globalService = Get.find<GlobalService>();

  @override
  _VerifyVideoPageState createState() => _VerifyVideoPageState();
}

class _VerifyVideoPageState extends State<VerifyVideoPage> with SingleTickerProviderStateMixin {
  List<Color> rectColors = List.filled(90, Color(0xFFE0E0E0));
  List<double> rectScales = List.filled(90, 1.0);
  bool isAnimating = false;
  String displayText = ConstantData.turnLeftText;
  CameraController? cameraController;
  bool isRecording = false;
  bool isCameraInitialized = false;
  final GlobalService _globalService = Get.find<GlobalService>();


  @override
  void initState() {
    super.initState();
    _initializeCamera();
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
            middleText: ConstantData.verifyVideoText,
            child: Container(),
          ),
          Positioned(
            top: 150.h,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 256.w,
                    height: 256.w,
                    child: CustomPaint(
                      painter: CirclePainter(rectColors: rectColors, rectScales: rectScales),
                    ),
                  ),
                  SizedBox(
                    width: 246.w,
                    height: 246.w,
                    child: ClipOval(
                      child: isCameraInitialized && cameraController != null && cameraController!.value.isInitialized
                          ? CameraPreview(cameraController!)
                          : Container(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 450.h,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                displayText,
                style: ConstantStyles.displayTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 530.h,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                ConstantData.followPromptsText,
                style: ConstantStyles.followPromptsTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 150.h,
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: ConstantData.startText,
                onPressed: () {
                  startAnimation();
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


  Future<void> _initializeCamera() async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }

    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    try {
      await cameraController!.initialize();
    } catch (e) {
      LogUtil.e('Error initializing camera: $e');
    }

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    try {
      await cameraController!.initialize();
      setState(() {});
    } catch (e) {
      LogUtil.e('Error initializing camera: $e');
    }
  }

  Future<String> _prepareVideoPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/verify_id_${DateTime.now().millisecondsSinceEpoch}.mp4';
  }

  Future<void> _startVideoRecording() async {
    await cameraController?.startVideoRecording();
  }

  Future<void> _runAnimation() async {
    const totalDuration = 15;
    const steps = 90;
    final stepDuration = totalDuration / steps;

    await _startVideoRecording();

    for (int i = 0; i < steps; i++) {
      await Future.delayed(Duration(milliseconds: (stepDuration * 1000).round()));
      if (mounted) {
        setState(() {
          rectColors[i] = Color(0xFFABFFCF);
          rectScales[i] = 1.5;

          if (i == 18) {
            displayText = ConstantData.turnRightText;
          } else if (i == 30) {
            displayText = ConstantData.nodText;
          } else if (i == 48) {
            displayText = ConstantData.blinkText;
          } else if (i == 60) {
            displayText = ConstantData.confirmIdText;
          }
        });
      }
    }

    final file = await _stopVideoRecording();
    if (file != null) {
      await _saveAndUploadVideo(file, await _prepareVideoPath());
    }
  }

  void startAnimation() async {
    if (isAnimating) return;
    setState(() => isAnimating = true);

    try {
      Map<String, bool> mediaPermissions = await _globalService.requestMediaPermissions();
      if (!mediaPermissions.values.every((granted) => granted)) {
        _showPermissionDeniedSnackbar(mediaPermissions);
        setState(() => isAnimating = false);
        return;
      }

      await _initializeCamera();

      if (cameraController == null || !cameraController!.value.isInitialized) {
        LogUtil.e('Camera failed to initialize');
        setState(() => isAnimating = false);
        return;
      }

      setState(() {
        isCameraInitialized = true;
      });

      await _runAnimation();
    } catch (e) {
      LogUtil.e('Error during video recording: $e');
    } finally {
      setState(() => isAnimating = false);
    }
  }


  void _updatePromptText() {
    Future.delayed(Duration(seconds: 3), () => setState(() => displayText = ConstantData.turnRightText));
    Future.delayed(Duration(seconds: 5), () => setState(() => displayText = ConstantData.nodText));
    Future.delayed(Duration(seconds: 8), () => setState(() => displayText = ConstantData.blinkText));
    Future.delayed(Duration(seconds: 10), () => setState(() => displayText = ConstantData.confirmIdText));
  }

  Future<XFile?> _stopVideoRecording() async {
    return await cameraController?.stopVideoRecording();
  }

  Future<void> _saveAndUploadVideo(XFile file, String videoPath) async {
    await File(file.path).copy(videoPath);
    LogUtil.d('Video saved to: $videoPath');

    final attachId = await _globalService.uploadFile(videoPath, widget.tokenEntity.accessToken.toString());
    if (attachId != null) {
      LogUtil.d('Video uploaded successfully. AttachId: $attachId');
    } else {
      LogUtil.e('Failed to upload video');
    }
  }

  void _showPermissionDeniedSnackbar(Map<String, bool> permissionResults) {
    List<String> deniedPermissions = permissionResults.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();

    Get.snackbar(
      'Permissions Denied',
      'Unable to record video. The following permissions were denied: ${deniedPermissions.join(", ")}. Please grant these permissions in settings.',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
      mainButton: TextButton(
        child: Text('Settings'),
        onPressed: () => openAppSettings(),
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

}
