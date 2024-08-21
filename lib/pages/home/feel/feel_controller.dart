import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';

class FeelController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments?['token'] as TokenEntity;
  var userList = <ListUserEntity>[].obs;
  var isLoading = true.obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      isLoading.value = true;
    }

    if (!hasMore.value && isLoadMore) {
      return;
    }

    const String url = 'https://api.masonvips.com/v1/liked_users';
    try {
      await DioClient.instance.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: url,
        queryParameters: {'page': currentPage.value, 'per_page': 20},
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          final fetchedData = (data ?? [])
              .map((e) => ListUserEntity.fromJson(e))
              .toList();

          if (isLoadMore) {
            userList.addAll(fetchedData);
          } else {
            userList.assignAll(fetchedData);
          }

          // 如果获取的数据少于请求的数量，假设没有更多数据
          hasMore.value = fetchedData.length >= 20;
          isLoading.value = false;
        },
        onError: (code, msg, data) {
          print('Error fetching data: $msg');
          isLoading.value = false;
        },
      );
    } catch (e) {
      print('Error fetching data: $e');
      isLoading.value = false;
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
}