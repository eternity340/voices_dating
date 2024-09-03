/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_mpwh/entity/response_entity.dart';
import 'package:flutter_mpwh/service/globalService.dart';
import 'package:flutter_mpwh/widgets/snackbar.dart';
import 'package:get/get.dart';

import '../../net/dio_utils.dart';
import '../../net/request.dart';
import '../../route/mpwh_routes.dart';
import '../../widgets/commonAlertDialog.dart';
import '../../widgets/dialog_email_verify.dart';
import '../../widgets/loading.dart';
import '../../widgets/loading_widget.dart';

import 'recaptcha_sheet.dart';

class SigninPageLogic extends GetxController {
  //更改密码可见性
  var passWord = true.obs;

  //用户登录信息
  String email = "";
  String password = "";

  //默认标题组件
  var defaultPageTitle = "Here To Get Welcome!".obs;
  var errorPageText = Colors.white.obs;


  void login(
      {String? verifyKey, String? verifyCode, String? reCaptchaKey}) async {
    //发送登录请求
    if (Get.isDialogOpen == false) {
      showLoading();
    }

    var params = {'email': email.trim(), 'password': password.trim()};
    if (reCaptchaKey != null && reCaptchaKey.isNotEmpty) {
      params.putIfAbsent('reCaptchaKey', () => reCaptchaKey);
    } else if (verifyKey != null &&
        verifyCode != null &&
        verifyCode.isNotEmpty) {
      params.putIfAbsent('twoFactorKey', () => verifyKey);
      params.putIfAbsent('twoFactorCode', () => verifyCode);
    }
    BaseResponse result = await loginInCount(params: params);

    hideLoading();
    if (result.code != 200) {
      //若请求返回失败，改变pageTitle

      if (result.code == 30001055) {
        // Get.toNamed(RouteConfig.pathSuspend);

        return;
      }
      if (result.code == 30001021) {
        showCommonDialog(
          needCancelBtn: true,
          content:
          'Your account is currently disabled. Would you like to reactivate it and post your profile online again?',
          callback: () {
            // _enableAccount();
          },
        );
        return;
      }
      if (result.code == 30001052) {
        if (result.data.twoFactorKey != null &&
            result.data.twoFactorKey!.isNotEmpty) {
          showEmailVerifyDialog(
              clickCallback: (code) {
                login(verifyKey: result.data.twoFactorKey, verifyCode: code);
              },
              email: email);
          return;
        }
      }
      if (result.code == 30001051) {
        //底部弹窗
        showRecaptcha(Get.context!, result.data.siteKey, (value) {
          _postRecaptcha(value);
        });
        return;
      }
      if (result.code == 30001096) {
        showSnackBar(result.message!);
        return;
      }
      if (result.code == 0) {
        showSnackBar(result.message!);
        return;
      }
      errorPageText.value = const Color.fromARGB(255, 0xFF, 0X7B, 0x6A);
      defaultPageTitle.value = "Invalid email address or password.";
    } else {
      //跳转主页
      var globalService = Get.find<GlobalService>();
      await globalService.setUserAccount(result.data);
      Get.offAllNamed(MpwhRoutes.pathHome);
    }
  }

  _postRecaptcha(String recaptcha) async {
    showLoading();
    BaseResponse result =
    await googleVerify(params: {'reCaptchaKey': recaptcha});

    if (result.code == 200) {
      login(reCaptchaKey: recaptcha);
    } else {
      hideLoading();
      showSnackBar(result.message!);
    }
  }

}
*/
