import 'package:dio/dio.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:get/get.dart';
import '../../../components/custom_content_dialog.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import '../../../utils/event_bus.dart';

class GameController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments?['tokenEntity'] as TokenEntity;
  var userList = <ListUserEntity>[].obs;
  var isInitialLoading = true.obs;
  var isRefreshing = false.obs;
  var currentPage = 1;
  var hasMore = true.obs;
  final DioClient dioClient = DioClient.instance;

  @override
  void onInit() {
    super.onInit();
    fetchData(isInitial: true);
    EventBus().onUserReported.listen((userId) {
      removeUser(userId);
    });
  }

  Future<void> fetchData({bool isLoadMore = false, bool isInitial = false}) async {
    if (isInitial) {
      isInitialLoading.value = true;
    } else if (!isLoadMore) {
      isRefreshing.value = true;
    }

    if (!hasMore.value && isLoadMore) {
      return;
    }

    const String url = ApiConstants.search;
    try {
      final response = await dioClient.requestNetwork<List<ListUserEntity>>(
        method: Method.get,
        url: url,
        queryParameters: {
          'page': currentPage,
          'offset': 20,
        },
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null) {
            final filteredData = data.where((user) => user.verified == "1").toList();

            if (isLoadMore) {
              userList.addAll(filteredData);
            } else {
              userList.assignAll(filteredData);
            }

            // 修改hasMore的判断逻辑
            hasMore.value = data.isNotEmpty; // 只有当返回的数据为空时，才认为没有更多数据

            currentPage++; // 每次成功加载后都增加页码
          }

          if (userList.isEmpty && !isLoadMore) {
            showNoDataDialog();
          }
        },
        onError: (code, msg, data) {
          if (!isLoadMore) {
            showNoDataDialog();
          }
        },
      );
      return response;
    } catch (e) {
      if (!isLoadMore) {
        showNoDataDialog();
      }
    } finally {
      isInitialLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void showNoDataDialog() {
    Get.dialog(
      CustomContentDialog(
        title: ConstantData.noticeText,
        content: ConstantData.noticeAboutLiked,
        buttonText: ConstantData.okText,
        onButtonPressed: () {
          Get.back(); // Close the dialog
          Get.back(); // Return to the previous page
        },
      ),
    );
  }

  Future<void> onRefresh() async {
    currentPage = 1;
    hasMore.value = true;
    await fetchData();
  }

  Future<void> onLoad() async {
    if (hasMore.value) {
      await fetchData(isLoadMore: true);
    }
  }

  void removeUser(String userId) {
    userList.removeWhere((user) => user.userId == userId);
    update(); // 通知 UI 更新
  }
}

