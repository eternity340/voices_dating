import 'package:camera/camera.dart';
import 'package:common_utils/common_utils.dart';
import 'package:first_app/components/background.dart';
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
import 'components/Circle_painter.dart';

class VerifyIDPage extends StatefulWidget {
  final TokenEntity tokenEntity = Get.arguments['token'];
  final UserDataEntity userData = Get.arguments['userData'];

  @override
  _VerifyIDPageState createState() => _VerifyIDPageState();
}

class _VerifyIDPageState extends State<VerifyIDPage> with SingleTickerProviderStateMixin {
  List<Color> rectColors = List.filled(90, Color(0xFFE0E0E0));
  List<double> rectScales = List.filled(90, 1.0);
  bool isAnimating = false;
  String displayText = ConstantData.turnLeftText;
  CameraController? cameraController;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    await cameraController!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
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
            middleText: ConstantData.verifyIdText,
            child: Container(),
          ),
          if (cameraController != null && cameraController!.value.isInitialized)
            Positioned(
              top: 150.h,
              left: 50.w,
              right: 50.w,
              child: Stack(
                children: [
                  SizedBox(
                    width: 256.w,
                    height: 286.h,
                    child: CustomPaint(
                      painter: CirclePainter(rectColors: rectColors, rectScales: rectScales),
                    ),
                  ),
                  SizedBox(
                    width: 250.w,
                    height: 286.h,
                    child: ClipOval(
                      child: CameraPreview(cameraController!),
                    ),
                  ),
                ],
              ),
            ),
          Positioned(
            top: 480.h,
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
            top: 600.h,
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
        ],
      ),
    );
  }

  void startAnimation() async {
    if (isAnimating) return;
    isAnimating = true;

    const duration = 15;
    const steps = 90;
    final stepDuration = duration / steps;

    if (await Permission.camera.request().isGranted && await Permission.microphone.request().isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      final videoPath = '${directory.path}/verify_id_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await cameraController?.startVideoRecording();
      for (int i = 0; i < steps; i++) {
        Future.delayed(Duration(milliseconds: (stepDuration * 1000).round() * i), () {
          setState(() {
            rectColors[i] = Color(0xFFABFFCF);
            rectScales[i] = 1.5;
          });
        });
      }
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          displayText = ConstantData.turnRightText;
        });
      });
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          displayText = ConstantData.nodText;
        });
      });
      Future.delayed(Duration(seconds: 8), () {
        setState(() {
          displayText = ConstantData.blinkText;
        });
      });
      Future.delayed(Duration(seconds: 10), () {
        setState(() {
          displayText = ConstantData.confirmIdText;
        });
      });
      Future.delayed(Duration(seconds: duration), () async {
        await cameraController?.stopVideoRecording();
        setState(() {
          isAnimating = false;
        });
        LogUtil.d(videoPath);
      });
    } else {
      setState(() {
        isAnimating = false;
      });
    }
  }
}
