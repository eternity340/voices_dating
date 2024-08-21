import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:first_app/utils/date_time_format.dart';

import '../constants/constant_data.dart';
import '../resources/string_res.dart';
import 'app_style_utils.dart';
import 'config_options_utils.dart';
import 'string_extension.dart';

class CommonUtils{

  static const leastPwdLength = 6;
  static const int oneMinTime = 60 * 1000;
  static const int oneHourTime = 60 * oneMinTime;

  static const int oneDayTime = 24 * oneHourTime;
  static const int oneWeekTime = 7 * oneDayTime;
  static const int oneMonthTime = 4 * oneWeekTime;


  static String randomBit(int len) {
    String scopeF = "123456789"; //first
    String scopeC = "0123456789"; //middle
    String result = "";
    for (int i = 0; i < len; i++) {
      if (i == 0) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return result;
  }

  static String getSignKey({required String appId,required String appSecret,required int time, required String nonce}) {
    var bytes = utf8.encode("$time${appId}${appSecret}$nonce");
    var digest = md5.convert(bytes);

    return digest.toString();
  }

  static String getSigngure({required String appId,required String appSecret,required int time, required String nonce}) {
    var bytes = utf8.encode("$time${appId}$nonce");
    var digest = md5.convert(bytes);

    return digest.toString();
  }

  static String getCmData({required int key}){
    String heightStr = ConfigOptionsUtils.getValueByKey(type: ProfileType.height, key: key);

    return formatHeightData(heightStr);
  }

  static String formatHeightData(String heightStr){
    int cmStart = heightStr.indexOf('(');
    int cmEnd = heightStr.indexOf(')');

    return heightStr.substring(cmStart+1,cmEnd).replaceAll("cm", "").trim();
  }

  static String formatNum(double num,int postion){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
      return num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }else{
      return num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }
  }


  static String randomName(int min,int max) {

    StringBuffer nameBuf = StringBuffer("");
    int nameLength=(Random().nextDouble()*(max-min+1)).toInt()+min;
    nameBuf.write(String.fromCharCode((Random().nextDouble()*26).toInt()+65));
    for(int i=1;i<nameLength;i++) {
      nameBuf.write(String.fromCharCode((Random().nextDouble()*26).toInt()+97));
    }
    return nameBuf.toString();
  }

  static hideSoftKeyboard({required BuildContext context}){
    FocusNode blankNode = FocusNode();
    FocusScope.of(context).requestFocus(blankNode);
  }

  static bool isEmpty(String? text) {
    return text == null || text.isEmpty;
  }

  static showToast({required String message,}){
    Fluttertoast.showToast(msg: message,gravity: ToastGravity.CENTER,backgroundColor: Colors.grey,textColor: Colors.white);
  }

  static showLoading({bool dismissible = true}) {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(
        const Center(
          child: SpinKitCircle(
            color: Color(0xFFABFFCF), // 使用 #ABFFCF 颜色
            size: 50.0,
          ),
        ),
        barrierDismissible: dismissible,
      );
    }
  }

  static hideLoading(){
    if(Get.isDialogOpen??false){
      Get.back();
    }
  }


  static SnackbarController showSnackBar(String message,
      {SnackBarType snackBarType = SnackBarType.error}) {
    final Color backgroundColor;
    final Widget messageHeader;
    final TextStyle textStyle;
    switch (snackBarType) {
      case SnackBarType.error:
        backgroundColor = AppStyleUtils.errorContainerColor;
        messageHeader = const Icon(Icons.dangerous_outlined, color: Colors.white);
        textStyle = AppStyleUtils.labelStyles.copyWith(color: Colors.white);
        break;
      case SnackBarType.success:
        backgroundColor = AppStyleUtils.itemSelectedColor;
        messageHeader =
        const Icon(Icons.offline_pin_outlined, color: Colors.green);
        textStyle = AppStyleUtils.labelStyles;
        break;
    }
    return Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.TOP,
      borderRadius: 12.r,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      barBlur: 7.0,
      backgroundColor: backgroundColor,
      dismissDirection: DismissDirection.up,
      snackStyle: SnackStyle.FLOATING,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeOutCirc,
      animationDuration: const Duration(milliseconds: 1500),
      overlayBlur: 0.0,
      overlayColor: Colors.transparent,
      messageText: Row(
        children: [
          messageHeader,
          SizedBox(width: 8.w,),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.start,
              style: textStyle,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ));
  }

  static String buildAddressStr({String? country, String? state, String? city}) {
    StringBuffer addressBuf =  StringBuffer();

    if (city.hasData) {
      addressBuf.write(city);
    }

    if (state.hasData) {
      addressBuf.write(", ${state}");
    }

    if (country.hasData) {
      addressBuf.write(", ${country}");
    }
    if (addressBuf.length > 0) {
      String addressStr = addressBuf.toString();
      if (addressStr.substring(0, 1) == ',') {
        addressStr = addressStr.replaceFirst(', ', "");
      }
      return addressStr;
    } else {
      return "";
    }
  }

  static String getGenderFull({String? genderType}) {
    if(genderType.isNullOrEmpty) {
      return "";
    }
    int gender = int.parse(genderType!);

    if (gender == ConstantData.genderTypeWomen) {
      return StringRes.getString(StringRes.woman);
    } else if (gender == ConstantData.genderTypeMen) {
      return StringRes.getString(StringRes.man);
    }
    return "";
  }

  static sendEmail(String emailAddress) {
    launchUrlString("mailto:$emailAddress");
  }

  static String? validatePwd({ String? pwd}) {
    bool isEmpty = pwd.isNullOrEmpty;
    String? result;
    if (!isEmpty) {
      pwd!.length >= leastPwdLength
          ? result = null
          : result = StringRes.getString(StringRes.errorPwdLengthError);
    } else {
      result = StringRes.getString(StringRes.errorEmptyPwd);
    }
    return result;
  }

  static String getGenderAbb({String? type}) {
    if(type.isNullOrEmpty||type=="null") {
      return "";
    }

    int gender = int.parse(type!);
    if (gender == ConstantData.genderTypeWomen) {
      return "W";
    } else if (gender == ConstantData.genderTypeMen) {
      return "M";
    }  else {
      return "";
    }
  }


  static String getPastTimeForDisplay(int time) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int lastTime = time;
    if (time < 1000000000000 / 100) {
      //小于这个了,服务器返回的肯定是秒了,需要做个1000乘法
      lastTime = time * 1000;
    }
    int duration = currentTime - lastTime;

    if (duration < oneHourTime) {
      if (duration / oneMinTime > 1) {
        return '${duration ~/ oneMinTime} Mins ';
      } else {
        return StringRes.getString(StringRes.justNow);
      }
    } else if (duration < oneDayTime) {
      if (duration / oneHourTime > 1) {
        return '${duration ~/ oneHourTime} ${StringRes.getString(StringRes.hours)}';
      } else {
        return '${duration ~/ oneHourTime} ${StringRes.getString(StringRes.hour)}';
      }
    } else if (duration < 30 * oneDayTime) {
      if (duration / oneDayTime > 1) {
        return '${duration ~/ oneDayTime} ${StringRes.getString(StringRes.days)}';
      } else {
        return '${duration ~/ oneDayTime} ${StringRes.getString(StringRes.day)}';
      }
    } else {
      return '30 ${StringRes.getString(StringRes.days)}';
    }
  }

  static getMessageTime({required int timeMs}){

    bool isSameYear = yearIsEqualByMs(
        timeMs, DateTime.now().millisecondsSinceEpoch);
    String sendTime = DateTimeFormat.formatDate(
      DateTime.fromMillisecondsSinceEpoch(timeMs),
      isSameYear ? "MMM dd HH:mm" : "${DateTimeFormat.enDateFormat} HH:mm",);
    return sendTime;
  }

  static bool yearIsEqualByMs(int ms, int locMs) {
    return yearIsEqual(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) {
    return dateTime.year == locDateTime.year;
  }

}

enum SnackBarType {
  error(0),
  success(1);

  final int value;

  const SnackBarType(this.value);
}