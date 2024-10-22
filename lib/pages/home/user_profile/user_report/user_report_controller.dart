import 'dart:io';
import 'package:voices_dating/entity/user_data_entity.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/list_user_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../net/dio.client.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../service/global_service.dart';
import '../../../../utils/log_util.dart';

class UserReportController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity userDataEntity;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController textEditingController = TextEditingController();
  final GlobalService globalService = Get.find<GlobalService>();
  final DioClient dioClient = DioClient.instance;
  String selectedOption = '';
  String selectedImagePath = '';

  UserReportController(
      this.tokenEntity,
      this.userDataEntity);

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
      attachId = await globalService.uploadFile(
          selectedImagePath
      );
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
      final response = await dioClient.requestNetwork<Map<String, dynamic>>(
        method: Method.post,
        url: ApiConstants.blockUser,
        options: dio.Options(headers: {'token': tokenEntity.accessToken}),
        params: {
          'userId': userDataEntity.userId,
          'commentId': commentId,
          if (attachId != null) 'attachId': attachId,
          if (isOtherSelected) 'content': textEditingController.text,
        },
        onSuccess: (data) {
          if (data != null && data['code'] == 200) {
            Get.back();
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(message:msg);
        },
      );
    } catch (e) {
      LogUtil.e(message: e.toString());
    }
  }
  bool get isOtherSelected => selectedOption == ConstantData.otherOption;
}
