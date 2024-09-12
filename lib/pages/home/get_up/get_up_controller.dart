import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/api_constants.dart';

class GetUpController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userDataEntity;
  var moments = <MomentEntity>[].obs;
  var isLoading = false.obs;
  var page = 1;
  final int pageOffset = 5;
  late EasyRefreshController easyRefreshController;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['token'] as TokenEntity;
    userDataEntity = Get.arguments['userData'] as UserDataEntity;
    easyRefreshController = EasyRefreshController();
    fetchMoments();
  }

  @override
  void onClose() {
    easyRefreshController.dispose();
    super.onClose();
  }

  Future<void> fetchMoments({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
      moments.clear();
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      dio.Dio dioInstance = dio.Dio();
      dio.Response response = await dioInstance.get(
        ApiConstants.timelines,
        queryParameters: {
          'page': page,
          'offset': pageOffset,
          'filter[likes]': 1,
          'filter[day]': 30,
          'filter[photo]': 1,
          'filter[state]': userDataEntity.location!.stateId != null
              ? int.tryParse(userDataEntity.location!.stateId!) ?? 0
              : null,
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
        moments.addAll(fetchedMoments);
        page++;
      } else {
        print('Failed to load moments');
        easyRefreshController.finishLoad(noMore: true);
      }
    } catch (e) {
      print('Error: $e');
      easyRefreshController.finishLoad(noMore: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMoments() async {
    await fetchMoments(isRefresh: true);
    easyRefreshController.finishRefresh();
  }
}
