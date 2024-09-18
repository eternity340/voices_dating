import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/api_constants.dart';
import '../../../net/dio.client.dart';

class GetUpController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userDataEntity;
  var moments = <MomentEntity>[].obs;
  var isLoading = false.obs;
  var page = 1;
  final int pageOffset = 5;
  final DioClient dioClient = DioClient.instance;
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
      await dioClient.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: ApiConstants.timelines,
        queryParameters: {
          'page': page,
          'offset': pageOffset,
          'filter[likes]': 1,
          'filter[day]': 30,
          'filter[photo]': 1,
          'filter[country]': userDataEntity.location!.countryId != null
              ? int.tryParse(userDataEntity.location!.countryId!) ?? 0
              : null,
        },
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          if (data != null) {
            List<MomentEntity> fetchedMoments = data
                .map((json) => MomentEntity.fromJson(json as Map<String, dynamic>))
                .toList();
            moments.addAll(fetchedMoments);
            page++;
          } else {
            easyRefreshController.finishLoad(noMore: true);
          }
        },
        onError: (code, msg, data) {
          print('Error: $msg');
          easyRefreshController.finishLoad(noMore: true);
        },
      );
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
