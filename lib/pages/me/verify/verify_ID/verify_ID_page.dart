import 'package:camera/camera.dart';
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
  List<Color> rectColors = List.filled(90, Color(0xFFE0E0E0)); // 90个矩形的初始颜色
  List<double> rectScales = List.filled(90, 1.0); // 90个矩形的初始缩放比例
  bool isAnimating = false;
  String displayText = ConstantData.turnLeftText; // 初始显示文本
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
          // 包含相机预览和小矩形的堆叠
          if (cameraController != null && cameraController!.value.isInitialized)
            Positioned(
              top: 150.h,
              left: (MediaQuery.of(context).size.width - 246.w) / 2,
              child: Stack(
                children: [
                  SizedBox(
                    width: 246.w,
                    height: 246.h,
                    child: CustomPaint(
                      painter: CirclePainter(rectColors: rectColors, rectScales: rectScales),
                    ),
                  ),
                  SizedBox(
                    width: 246.w,
                    height: 246.h,
                    child: ClipOval(
                      child: CameraPreview(cameraController!),
                    ),
                  ),
                ],
              ),
            ),
          Positioned(
            top: 480.h, // 计算文字位置
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
            top: 530.h, // 居中计算
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

    const duration = 15; // 15秒
    const steps = 90; // 90个矩形
    final stepDuration = duration / steps;

    if (await Permission.camera.request().isGranted && await Permission.microphone.request().isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      final videoPath = '${directory.path}/verify_id_${DateTime.now().millisecondsSinceEpoch}.mp4';

      await cameraController?.startVideoRecording();

      // 动画
      for (int i = 0; i < steps; i++) {
        Future.delayed(Duration(milliseconds: (stepDuration * 1000).round() * i), () {
          setState(() {
            // 将当前矩形变为目标颜色
            rectColors[i] = Color(0xFFABFFCF);
            // 放大当前矩形
            rectScales[i] = 1.5; // 放大比例
          });
        });
      }

      // 文本更新
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

      // 动画结束后重置状态并停止录制视频
      Future.delayed(Duration(seconds: duration), () async {
        await cameraController?.stopVideoRecording();
        setState(() {
          isAnimating = false;
        });
        print("Video recorded to: $videoPath");
        // 你可以在这里添加代码来处理视频文件，比如上传到服务器或保存到本地
      });
    } else {
      // 权限请求被拒绝，处理错误
      print("Camera or Microphone permission denied");
      setState(() {
        isAnimating = false;
      });
    }
  }
}
