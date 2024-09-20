import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/net/dio.client.dart';
import 'package:voices_dating/service/token_service.dart';
import 'package:voices_dating/utils/shared_preference_util.dart';
import 'package:voices_dating/utils/string_ext.dart';

class ReplaceWordUtil {
  static ReplaceWordUtil? _instance;
  static Map<String, String> words = {};

  static ReplaceWordUtil getInstance() {
    _instance ??= ReplaceWordUtil._internal();
    return _instance!;
  }

  ReplaceWordUtil._internal();

  Future<void> getReplaceWord() async {
    await loadWordsFromLocalStorage();
    await fetchWordsFromServer();
  }

  Future<void> loadWordsFromLocalStorage() async {
    if (words.isNotEmpty) return;
    var temp = await SharedPreferenceUtil.instance.getValue(key: 'replaceWords');
    if (temp is Map) {
      words = Map<String, String>.from(temp);
    }
  }

  Future<void> fetchWordsFromServer() async {
    try {
      await DioClient.instance.requestNetwork<dynamic>(
        method: Method.get,
        url: ApiConstants.getReplaceWords,
        options: Options(headers: {'token': await TokenService.instance.getToken()}),
        onSuccess: _handleSuccessResponse,
        onError: _handleErrorResponse,
      );
    } catch (e) {
      LogUtil.e(e.toString());
    }
  }

  void _handleSuccessResponse(dynamic value) {
    if (value is Map<String, dynamic>) {
      words = Map<String, String>.from(value);
      SharedPreferenceUtil.instance.setValue(key: 'replaceWords', value: words);
    }
  }

  void _handleErrorResponse(code, msg, data) {
    LogUtil.e(msg);
  }

  dynamic replaceWordsInJson(dynamic data, {bool isSelf = false}) {
    if (data is Map<String, dynamic>) {
      return data.map((key, value) => MapEntry(key, replaceWordsInJson(value, isSelf: isSelf)));
    } else if (data is List) {
      return data.map((e) => replaceWordsInJson(e, isSelf: isSelf)).toList();
    } else if (data is String) {
      return data.replaceWord(isSelf);
    } else {
      return data;
    }
  }
}
