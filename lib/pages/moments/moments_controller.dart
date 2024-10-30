import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/api_constants.dart';
import '../../../net/dio.client.dart';
import '../../utils/event_bus.dart';

class MomentsController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userDataEntity;
  var moments = <MomentEntity>[].obs;
  var isLoading = false.obs;
  var page = 1;
  final int pageOffset = 5;
  late EasyRefreshController easyRefreshController;
  final DioClient dioClient = DioClient.instance;
  var isInitialLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    userDataEntity = Get.arguments['userDataEntity'] as UserDataEntity;
    easyRefreshController = EasyRefreshController();
    fetchMoments();
    EventBus().onUserReported.listen((userId) {
      removeUser(userId);
    });
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
          //'filter[likes]': 1,
          //'filter[day]': 30,
          //'filter[photo]': 0,

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
      isInitialLoading.value = false;
    }
  }

  Future<void> refreshMoments() async {
    await fetchMoments(isRefresh: true);
    easyRefreshController.finishRefresh();
  }

  void removeUser(String userId) {
    moments.removeWhere((moment) => moment.userId == userId);
    update(); // 通知 UI 更新
  }

  @override
  void onClose() {
    easyRefreshController.dispose();
    super.onClose();
  }
}
