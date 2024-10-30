import 'package:dio/dio.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:get/get.dart';
import '../../../components/custom_content_dialog.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import '../../../utils/event_bus.dart';

class FeelController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments?['tokenEntity'] as TokenEntity;
  var userList = <ListUserEntity>[].obs;
  var isInitialLoading = true.obs;
  var isLoading = true.obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;
  final DioClient dioClient = DioClient.instance;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    EventBus().onUserReported.listen((userId) {
      removeUser(userId);
    });
  }

  Future<void> fetchData({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      isLoading.value = true;
    }

    if (!hasMore.value && isLoadMore) {
      return;
    }

    const String url = ApiConstants.likedUser;
    try {
      await dioClient.requestNetwork<List<ListUserEntity>>(
        method: Method.get,
        url: url,
        queryParameters: {
          'page': currentPage.value,
          'offset': 20
        },
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null) {
            if (isLoadMore) {
              userList.addAll(data);
            } else {
              userList.assignAll(data);
            }
            hasMore.value = data.length >= 20;
          }
          isInitialLoading.value = false;
          isLoading.value = false;

          if (userList.isEmpty && !isLoadMore) {
            showNoDataDialog();
          }
        },
        onError: (code, msg, data) {
          isInitialLoading.value = false;
          isLoading.value = false;
          if (!isLoadMore) {
            showNoDataDialog();
          }
        },
      );
    } catch (e) {
      isInitialLoading.value = false;
      isLoading.value = false;
      if (!isLoadMore) {
        showNoDataDialog();
      }
    }
  }

  void showNoDataDialog() {
    Get.dialog(
      CustomContentDialog(
        title: ConstantData.noticeText,
        content: ConstantData.noticeAboutLiked,
        buttonText: ConstantData.okText,
        onButtonPressed: () {
          Get.back();
          //Get.back();
        },
      ),
    );
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

  void removeUser(String userId) {
    userList.removeWhere((user) => user.userId == userId);
    update();
  }
}
