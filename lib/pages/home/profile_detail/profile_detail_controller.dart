import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/option_entity.dart';
import '../../../entity/ret_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../entity/chatted_user_entity.dart';
import '../../../entity/wink_entity.dart';
import '../../../net/dio.client.dart';
import '../../../routes/app_routes.dart';
import '../../../service/global_service.dart';
import '../../../utils/shared_preference_util.dart';
import '../../../components/custom_message_dialog.dart';
import '../components/wink_selection_bottom_sheet.dart';

class ProfileDetailController extends GetxController {
  final ListUserEntity userEntity;
  final TokenEntity tokenEntity;
  late UserDataEntity? userDataEntity;
  final DioClient dioClient = DioClient.instance;
  final GlobalService globalService = Get.find<GlobalService>();
  RxString languageLabel = RxString('');
  RxBool isLoading = true.obs;
  RxList<WinkEntity> winkTypes = <WinkEntity>[].obs;

  ProfileDetailController({required this.userEntity, required this.tokenEntity});

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      await _initUserData();
      await _fetchLanguageLabel();
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initUserData() async {
    final userDataJson = await SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.selfEntity);
    if (userDataJson != null) {
      try {
        final Map<String, dynamic> userDataMap = json.decode(userDataJson);
        userDataEntity = UserDataEntity.fromJson(userDataMap);
      } catch (e) {
        _showErrorDialog();
      }
    } else {
      _showErrorDialog();
    }
  }

  Future<void> _fetchLanguageLabel() async {
    try {
      List<OptionEntity> languageOptions = await globalService.getLanguageOptions();
      String? userLanguage = userEntity.language;
      if (userLanguage != null) {
        OptionEntity? matchingOption = languageOptions.firstWhereOrNull(
                (option) => option.id == userLanguage
        );
        if (matchingOption != null) {
          languageLabel.value = matchingOption.label ?? '';
        }
      }
    } catch (e) {
      print('Error fetching language label: $e');
    }
  }

  void onWinkButtonPressed() {
    WinkSelectionBottomSheet.show(
      title: ConstantData.winkTitle,
      onItemSelected: (WinkEntity selectedWink) {
        _sendWink(selectedWink);
      },
    );
  }

  void _sendWink(WinkEntity selectedWink) {
    dioClient.requestNetwork<RetEntity>(
      method: Method.post,
      url: ApiConstants.setWinkedUser,
      options: Options(headers: {'token': tokenEntity.accessToken}),
      params: {
        'profId': userEntity.userId,
        'winkedType': selectedWink.id,
        'userId': userDataEntity?.userId,
      },
      onSuccess: (data) {
        if (data != null && data.ret) {
          Get.snackbar(ConstantData.successText, 'Wink sent successfully');
        } else {
          Get.snackbar(ConstantData.failedText, 'Failed to send wink');
        }
      },
      onError: (code, msg, data) {
        if(code == 30004019){
          Get.snackbar(ConstantData.sorryText, msg);
        }else{
          Get.snackbar(ConstantData.errorText, msg);
        }
      },
    );
  }

  void onCallButtonPressed() {

  }

  void onChatButtonPressed() {
    if (userDataEntity == null) {
      _showErrorDialog();
      return;
    }

    ChattedUserEntity chattedUser = ChattedUserEntity(
      userId: userEntity.userId,
      username: userEntity.username,
      avatar: userEntity.avatar,
    );

    Get.toNamed(AppRoutes.messagePrivateChat, arguments: {
      'tokenEntity': tokenEntity,
      'chattedUser': chattedUser,
      'userDataEntity': userDataEntity
    });
  }

  void _showErrorDialog() {
    Get.dialog(
      CustomMessageDialog(
        title: Text(ConstantData.failedText),
        content: Text(ConstantData.userDataNotFound),
        onYesPressed: () {
          Get.offAllNamed(AppRoutes.welcome);
        },
      ),
    );
  }

  void blockUser() {
    DioClient.instance.requestNetwork<RetEntity>(
      method: Method.post,
      url: ApiConstants.blockUser,
      queryParameters: {'userId': userEntity.userId},
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null && data.ret) {
          Get.back();
          Get.snackbar(ConstantData.successText, ConstantData.userHasBlocked);
        } else {
          Get.snackbar(ConstantData.failedText, ConstantData.failedBlocked);
        }
      },
      onError: (code, msg, data) {
        Get.snackbar(ConstantData.errorText, msg);
      },
    );
  }
}