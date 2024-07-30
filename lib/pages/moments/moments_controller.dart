import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../entity/token_entity.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/user_data_entity.dart';

class MomentsController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;
  var moments = <MomentEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['token'] as TokenEntity;
    userData = Get.arguments['userData'] as UserDataEntity;
    fetchMoments();
  }

  Future<void> fetchMoments() async {
    try {
      dio.Dio dioInstance = dio.Dio();
      dio.Response response = await dioInstance.get(
        'https://api.masonvips.com/v1/timelines',
        queryParameters: {
          'filter[likes]': 1,
          'filter[day]': 30,
          'filter[photo]': 1,
          'profId': 2307754,
        },
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (response.data['code'] == 200) {
        List<dynamic> momentsJson = response.data['data'];
        List<MomentEntity> fetchedMoments = momentsJson
            .map((json) => MomentEntity.fromJson(json as Map<String, dynamic>))
            .toList();
        moments.assignAll(fetchedMoments);
      } else {
        print('Failed to load moments');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
