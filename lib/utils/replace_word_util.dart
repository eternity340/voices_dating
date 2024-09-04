import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/net/dio.client.dart';
import 'package:first_app/utils/shared_preference_util.dart';
import 'package:first_app/entity/token_entity.dart';
import '../constants/constant_data.dart';

class ReplaceWordUtil {
  static ReplaceWordUtil? _instance;
  static Map<String, String> words = {};
  late TokenEntity tokenEntity;

  static ReplaceWordUtil getInstance() {
    _instance ??= ReplaceWordUtil._internal();
    return _instance!;
  }

  ReplaceWordUtil._internal() {
    initializeToken();
  }

  void initializeToken() {
    final tokenJson = SharedPreferenceUtil.instance.getValue(key: SharedPresKeys.userToken);
    if (tokenJson != null) {
      tokenEntity = TokenEntity.fromJson(json.decode(tokenJson));
    } else {
      LogUtil.e(ConstantData.noTokenInLocal);
    }
  }

  Future<void> getReplaceWord() async {
    loadWordsFromLocalStorage();
    await fetchWordsFromServer();
  }

  void loadWordsFromLocalStorage() {
    if (words.isNotEmpty) return;
    var temp = SharedPreferenceUtil.instance.getValue(key: 'replaceWords');
    if (temp is! Map) return;
    temp.forEach((key, value) {
      if (value is String) {
        words[key] = value;
      }
    });
  }

  Future<void> fetchWordsFromServer() async {
    try {
      await DioClient.instance.requestNetwork<dynamic>(
        method: Method.get,
        url: ApiConstants.getReplaceWords,
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: _handleSuccessResponse,
        onError: _handleErrorResponse,
      );
    } catch (e) {
      LogUtil.e(e.toString());
    }
  }

  void _handleSuccessResponse(dynamic value) {
    if (value is! Map<String, dynamic>) return;
    words.clear();
    value.forEach((key, value) {
      if (value is String) {
        words[key] = value;
      }
    });
    SharedPreferenceUtil.instance.setValue(key: 'replaceWords', value: value);
  }

  void _handleErrorResponse( code, msg, data) {
    LogUtil.e(msg);
  }


  String replaceWords(String? text) {
    if (text == null || text.isEmpty) return '';

    words.forEach((key, value) {
      text = text!.replaceAll(key, value);
    });

    return text!;
  }
}
