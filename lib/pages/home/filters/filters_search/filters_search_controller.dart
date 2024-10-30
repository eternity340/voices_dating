import 'package:dio/dio.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:get/get.dart';

import '../../../../components/custom_content_dialog.dart';
import '../../../../entity/list_user_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../net/dio.client.dart';
import '../../../../utils/event_bus.dart';


class FiltersSearchController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final Map<String, dynamic> filterParams = Get.arguments?['filterParams'] as Map<String, dynamic>;

  var userList = <ListUserEntity>[].obs;
  var isLoading = true.obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;
  final DioClient dioClient = DioClient.instance;
  var initialLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(isInitial: true);
    EventBus().onUserReported.listen((userId) {
      removeUser(userId);
    });
  }


  Future<void> fetchData({bool isLoadMore = false, bool isInitial = false}) async {
    if (!_shouldFetchData(isLoadMore, isInitial)) return;

    try {
      await performNetworkRequest(isLoadMore);
    } catch (e) {
      _handleError(isLoadMore);
    } finally {
      if (isInitial) {
        initialLoading.value = false;
      }
    }
  }

  bool _shouldFetchData(bool isLoadMore, bool isInitial) {
    if (isInitial) {
      initialLoading.value = true;
      return true;
    }
    return isLoadMore ? hasMore.value : true;
  }

  void _handleSuccess(List<ListUserEntity>? data, bool isLoadMore) {
    if (data != null) {
      _updateUserList(data, isLoadMore);
      hasMore.value = data.length >= 20;
    }

    if (userList.isEmpty && !isLoadMore) {
      showNoDataDialog();
    }
  }

  void _handleError(bool isLoadMore) {
    if (!isLoadMore) {
      showNoDataDialog();
    }
  }

  Future<void> onRefresh() async {
    currentPage.value = 1;
    hasMore.value = true;
    await fetchData();
  }

  Future<void> onLoad() async {
    if (hasMore.value) {
      currentPage.value++;
      await fetchData(isLoadMore: true);
    }
  }

  Future<void> performNetworkRequest(bool isLoadMore) async {
    await dioClient.requestNetwork<List<ListUserEntity>>(
      method: Method.get,
      url: ApiConstants.search,
      queryParameters: queryParameters(),
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) => _handleSuccess(data, isLoadMore),
      onError: (code, msg, data) => _handleError(isLoadMore),
    );
  }

  Map<String, dynamic> queryParameters() {
    Map<String, dynamic> params = {
      'page': currentPage.value,
      'offset': 20,
    };

    // 添加年龄范围
    if (filterParams.containsKey('minAge')) {
      params['find[minAge]'] = filterParams['minAge'];
    }
    if (filterParams.containsKey('maxAge')) {
      params['find[maxAge]'] = filterParams['maxAge'];
    }

    // 添加寻找对象
    if (filterParams.containsKey('lookingFor')) {
      params['find[seeking]'] = filterParams['lookingFor'];
    }

    // 添加距离
    if (filterParams.containsKey('selectedDistance')) {
      params['find[distance]'] = filterParams['selectedDistance'];
    }

    // 添加地理位置信息
    if (filterParams.containsKey('countryId')) {
      params['find[country]'] = filterParams['countryId'];
    }
    if (filterParams.containsKey('stateId')) {
      params['find[state]'] = filterParams['stateId'];
    }
    if (filterParams.containsKey('cityId')) {
      params['find[city]'] = filterParams['cityId'];
    }

    return params;
  }

  void _updateUserList(List<ListUserEntity> data, bool isLoadMore) {
    if (isLoadMore) {
      userList.addAll(data);
    } else {
      userList.assignAll(data);
    }
  }

  void showNoDataDialog() {
    Get.dialog(
      CustomContentDialog(
        title:ConstantData.filterNoResultTitle      ,
        content: ConstantData.filterNoResultContent,
        buttonText: ConstantData.okText,
        onButtonPressed: () {
          Get.back();
          Get.back();
        },
      ),
    );
  }

  void removeUser(String userId) {
    userList.removeWhere((user) => user.userId == userId);
    update(); // 通知 UI 更新
  }
}
