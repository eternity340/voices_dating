import 'dart:io';
import 'package:camera/camera.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/service/app_service.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_content_dialog.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../net/dio.client.dart';
import '../../../../routes/app_routes.dart';
import '../../../../service/global_service.dart';

class VerifyVideoController extends GetxController {
  final GlobalService _globalService = Get.find<GlobalService>();
  final TokenEntity tokenEntity;
  final UserDataEntity userData;
  final DioClient dioClient = DioClient.instance;
  var rectColors = List.filled(90, Color(0xFFE0E0E0)).obs;
  var rectScales = List.filled(90, 1.0).obs;
  var isAnimating = false.obs;
  var displayText = ConstantData.turnLeftText.obs;
  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  var isRecording = false.obs;
  var isCameraInitialized = false.obs;

  VerifyVideoController({required this.tokenEntity, required this.userData});

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVerificationStatus();
    });
  }

  void checkVerificationStatus() {
    switch (userData.verified) {
      case '1':
        showApprovalVerificationDialog();
        break;
      case '2':
        showPendingVerificationDialog();
        break;
      case '3':
        showRejectedVerificationDialog();
        break;
      default:
      // 如果状态不是 1, 2, 或 3，可能需要额外的处理
        break;
    }
  }

  void showApprovalVerificationDialog() {
    Get.dialog(
      CustomContentDialog(
        title: ConstantData.verificationApprovalTitle,
        content: ConstantData.verificationApprovalMessage,
        buttonText: ConstantData.gotItText,
        onButtonPressed: () => Get.offAllNamed(AppRoutes.me, arguments: {
          'tokenEntity': tokenEntity,
          'userDataEntity': userData
        }),
      ),
      barrierDismissible: false,
    );
  }

  void showPendingVerificationDialog() {
    Get.dialog(
      CustomContentDialog(
        title: ConstantData.verificationPendingTitle,
        content: ConstantData.verificationPendingMessage,
        buttonText: ConstantData.gotItText,
        onButtonPressed: () => Get.toNamed(
          AppRoutes.meVerify,
          arguments: {
            'tokenEntity': tokenEntity,
            'userDataEntity': userData
          },
        ),
      ),
    );
  }

  void showRejectedVerificationDialog() {
    Get.dialog(
      CustomContentDialog(
        title: ConstantData.verificationRejectedTitle,
        content: ConstantData.verificationRejectedMessage,
        buttonText: ConstantData.yesText,
        onButtonPressed: () => Get.back(),
      ),
      barrierDismissible: false,
    );
  }


  Future<void> initializeCamera() async {
    if (cameraController.value != null) {
      await cameraController.value!.dispose();
    }

    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    cameraController.value = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    try {
      await cameraController.value!.initialize();
      isCameraInitialized.value = true;
      update();
    } catch (e) {
      LogUtil.e('Error initializing camera: $e');
    }
  }

  Future<void> startAnimation() async {
    if (isAnimating.value) return;
    isAnimating.value = true;

    try {
      Map<String, bool> mediaPermissions = await _globalService.requestMediaPermissions();
      if (!mediaPermissions.values.every((granted) => granted)) {
        _showPermissionDeniedSnackbar(mediaPermissions);
        isAnimating.value = false;
        return;
      }

      await initializeCamera();

      if (cameraController.value == null || !cameraController.value!.value.isInitialized) {
        LogUtil.e('Camera failed to initialize');
        isAnimating.value = false;
        return;
      }

      await _runAnimation();
    } catch (e) {
      LogUtil.e(e.toString());
    } finally {
      isAnimating.value = false;
    }
  }

  Future<void> _runAnimation() async {
    const totalDuration = 15;
    const steps = 90;
    final stepDuration = totalDuration / steps;

    await _startVideoRecording();

    for (int i = 0; i < steps; i++) {
      await Future.delayed(Duration(milliseconds: (stepDuration * 1000).round()));
      rectColors[i] = Color(0xFFABFFCF);
      rectScales[i] = 1.5;

      if (i == 18) {
        displayText.value = ConstantData.turnRightText;
      } else if (i == 30) {
        displayText.value = ConstantData.nodText;
      } else if (i == 48) {
        displayText.value = ConstantData.blinkText;
      } else if (i == 60) {
        displayText.value = ConstantData.confirmIdText;
      }

      update();
    }

    final file = await _stopVideoRecording();
    if (file != null) {
      await _saveAndUploadVideo(file, await _prepareVideoPath());
    }
  }

  Future<void> _startVideoRecording() async {
    await cameraController.value?.startVideoRecording();
    isRecording.value = true;
  }

  Future<XFile?> _stopVideoRecording() async {
    isRecording.value = false;
    return await cameraController.value?.stopVideoRecording();
  }

  Future<String> _prepareVideoPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/verify_id_${DateTime.now().millisecondsSinceEpoch}.mp4';
  }

  Future<void> _saveAndUploadVideo(XFile file, String videoPath) async {
    await File(file.path).copy(videoPath);
    LogUtil.d('Video saved to: $videoPath');

    final attachId = await _globalService.uploadFile(videoPath, tokenEntity.accessToken.toString());
    if (attachId != null) {
      LogUtil.d(attachId);

      await _sendVerifyRequest(attachId);
    } else {
      LogUtil.e('Failed to upload video');
    }
    _resetToInitialState();
  }

  Future<void> _sendVerifyRequest(String attachId) async {
    final url = ApiConstants.profileVideoVerify;
    final options = Options(
      headers: {
        'token': tokenEntity.accessToken,
      },
    );

    try {
      await dioClient.requestNetwork<void>(
        method: Method.post,
        url: url,
        params: {'videoId': attachId},
        options: options,
        onSuccess: (data) async {
          LogUtil.d(ConstantData.verifyVideoSuccessContent);
          Get.snackbar(ConstantData.successText, ConstantData.verifyVideoSuccessContent);
          await AppService.instance.updateStoredUserData({'verified': '2'});
          userData.verified = '2';

          await Future.delayed(Duration(seconds: 2));
          Get.offAllNamed(
            AppRoutes.me,
            arguments: {'tokenEntity': tokenEntity, 'userDataEntity': userData},
          );
        },
        onError: (code, msg, data) {
          LogUtil.e(msg);
          Get.snackbar(ConstantData.failedText, msg);
        },
      );
    } catch (e) {
      LogUtil.e(e.toString());
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }

  void _resetToInitialState() {
    rectColors.value = List.filled(90, Color(0xFFE0E0E0));
    rectScales.value = List.filled(90, 1.0);

    displayText.value = ConstantData.turnLeftText;

    if (cameraController.value != null) {
      cameraController.value!.dispose();
      cameraController.value = null;
    }

    isCameraInitialized.value = false;

    isRecording.value = false;
    isAnimating.value = false;
    update();
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
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }
}
