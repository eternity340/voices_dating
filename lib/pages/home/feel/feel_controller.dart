import 'package:dio/dio.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:get/get.dart';
import '../../../components/custom_content_dialog.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';

class FeelController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments?['tokenEntity'] as TokenEntity;
  var userList = <ListUserEntity>[].obs;
  var isLoading = true.obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;
  final DioClient dioClient = DioClient.instance;

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

    const String url = ApiConstants.likedUser;
    try {
      await dioClient.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: url,
        queryParameters: {
          'page': currentPage.value,
          'offset': 20
        },
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
          hasMore.value = fetchedData.length >= 20;
          isLoading.value = false;

          // 检查是否没有数据
          if (userList.isEmpty && !isLoadMore) {
            showNoDataDialog();
          }
        },
        onError: (code, msg, data) {
          isLoading.value = false;
          if (!isLoadMore) {
            showNoDataDialog();
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
      if (!isLoadMore) {
        showNoDataDialog();
      }
    }
  }

  void showNoDataDialog() {
    Get.dialog(
      CustomContentDialog(
        title:ConstantData.noticeText,
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
