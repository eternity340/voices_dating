import 'package:voices_dating/net/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/list_user_entity.dart';
import '../../../../entity/ret_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../net/dio.client.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../service/global_service.dart';
import '../../../../utils/event_bus.dart';
import '../../../../utils/log_util.dart';
import '../../home_controller.dart';
import '../../viewed/viewed_controller.dart';

class ReportController extends GetxController {
  final TokenEntity tokenEntity;
  final String userId;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController textEditingController = TextEditingController();
  final GlobalService globalService = Get.find<GlobalService>();
  final DioClient dioClient = DioClient.instance;
  String selectedOption = '';
  String selectedImagePath = '';

  ReportController(this.tokenEntity, this.userId);

  bool get isSubmitEnabled {
    return selectedOption.isNotEmpty;
  }

  void selectOption(String option) {
    if (selectedOption == option) {
      selectedOption = '';
    } else {
      selectedOption = option;
    }
    update();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath = pickedFile.path;
      update();
    }
  }

  Future<void> report() async {
    String? attachId;
    if (selectedImagePath.isNotEmpty) {
      attachId = await globalService.uploadFile(selectedImagePath);
    }

    int commentId;
    switch (selectedOption) {
      case ConstantData.pornographicOption:
        commentId = 15;
        break;
      case ConstantData.violentOption:
        commentId = 14;
        break;
      case ConstantData.maliciousAttackOption:
        commentId = 13;
        break;
      case ConstantData.disgustingOption:
        commentId = 10;
        break;
      case ConstantData.otherOption:
        commentId = 16;
        break;
      default:
        return;
    }

    try {
      final response = await dioClient.requestNetwork<RetEntity>(
        method: Method.post,
        url: ApiConstants.blockUser,
        options: dio.Options(headers: {'token': tokenEntity.accessToken}),
        params: {
          'userId': userId,
          'commentId': commentId,
          if (attachId != null) 'attachId': attachId,
          if (isOtherSelected) 'content': textEditingController.text,
        },
        onSuccess: (data) {
          if (data != null && data.ret == true) {
            // 举报成功后，发布用户被举报的事件
            EventBus().reportUser(userId);
            Get.back();
            Get.back();
            Get.snackbar(ConstantData.successText, 'User reported successfully');
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(message: msg);
          Get.back();
          Get.snackbar(ConstantData.failedText, msg);
        },
      );
    } catch (e) {
      LogUtil.e(message: e.toString());
      Get.back();
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }

  bool get isOtherSelected => selectedOption == ConstantData.otherOption;
}
