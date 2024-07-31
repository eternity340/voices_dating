import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';

class FeelController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments?['token'] as TokenEntity;
  final Dio dio = Dio();
  var userList = <ListUserEntity>[].obs;
  var isLoading = true.obs;
  var currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData({bool isLoadMore = false}) async {
    const String url = 'https://api.masonvips.com/v1/search';
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'page': currentPage.value,
          'offset': 20,
          'find[gender]': 2,
        },
        options: Options(headers: {'token': tokenEntity.accessToken}),
      );

      final fetchedData = (response.data['data'] as List)
          .map((e) => ListUserEntity.fromJson(e))
          .where((user) => user.liked != 0)
          .toList();

      if (isLoadMore) {
        userList.addAll(fetchedData);
      } else {
        userList.assignAll(fetchedData);
      }
      isLoading.value = false;
    } catch (e) {
      print('Error fetching data: $e');
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    currentPage.value = 1;
    await fetchData();
  }

  Future<void> onLoad() async {
    currentPage.value++;
    await fetchData(isLoadMore: true);
  }
}
