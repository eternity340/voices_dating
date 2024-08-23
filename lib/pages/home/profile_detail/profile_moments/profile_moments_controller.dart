import 'package:dio/dio.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/utils/log_util.dart';
import 'package:get/get.dart';
import '../../../../entity/moment_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../entity/list_user_entity.dart';
import '../../../../net/dio.client.dart';

class ProfileMomentsController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;
  late ListUserEntity userEntity;
  var moments = <MomentEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    userData = Get.arguments['userData'] as UserDataEntity;
    userEntity = Get.arguments['userEntity'] as ListUserEntity;
    fetchMoments();
  }

  Future<void> fetchMoments() async {
    DioClient().requestNetwork<List<MomentEntity>>(
      method: Method.get,
      url: 'https://api.masonvips.com/v1/timelines',
      queryParameters: {
        'profId': userEntity.userId,
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