import 'package:dio/dio.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/utils/log_util.dart';
import 'package:get/get.dart';
import '../../../../entity/moment_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../net/dio.client.dart';
import '../../../../utils/replace_word_util.dart';

class UserMomentsController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userDataEntity;
  var moments = <MomentEntity>[].obs;
  final ReplaceWordUtil replaceWordUtil = ReplaceWordUtil.getInstance();

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    userDataEntity = Get.arguments['userDataEntity'] as UserDataEntity;
    fetchMoments();
  }

  Future<void> fetchMoments() async {
    try {
      await replaceWordUtil.getReplaceWord(); // 确保替换词已加载

      await DioClient.instance.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: ApiConstants.timelines,
        queryParameters: {
          'profId': userDataEntity.userId,
        },
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          if (data != null) {
            List<MomentEntity> processedMoments = data.map((moment) {
              var processedMoment = replaceWordUtil.replaceWordsInJson(moment);
              return MomentEntity.fromJson(processedMoment);
            }).toList();
            moments.assignAll(processedMoments);
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(message: msg);
        },
      );
    } catch (e) {
      LogUtil.e(message: e.toString());
    }
  }
}
