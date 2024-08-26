import 'package:dio/dio.dart';
import 'package:first_app/utils/log_util.dart';
import 'package:get/get.dart';
import '../../../../entity/moment_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../net/dio.client.dart';

class UserMomentsController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userDataEntity;
  var moments = <MomentEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    userDataEntity = Get.arguments['userDataEntity'] as UserDataEntity;
    fetchMoments();
  }

  Future<void> fetchMoments() async {
    DioClient().requestNetwork<List<MomentEntity>>(
      method: Method.get,
      url: 'https://api.masonvips.com/v1/timelines',
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
          moments.assignAll(data);
        }
      },
      onError: (code, msg, data) {
        LogUtil.e(message: msg);
      },
    );
  }
}