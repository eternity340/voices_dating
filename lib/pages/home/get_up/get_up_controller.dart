import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../components/custom_content_dialog.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/api_constants.dart';
import '../../../net/dio.client.dart';
import '../../../utils/replace_word_util.dart';

class GetUpController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userDataEntity;
  var moments = <MomentEntity>[].obs;
  var isLoading = false.obs;
  var page = 1;
  final int pageOffset = 5;
  final DioClient dioClient = DioClient.instance;
  late EasyRefreshController easyRefreshController;
  bool _isDisposed = false;
  var isInitialLoading = true.obs;
  var hasError = false.obs;
  var isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['token'] as TokenEntity;
    userDataEntity = Get.arguments['userData'] as UserDataEntity;
    easyRefreshController = EasyRefreshController();
    ReplaceWordUtil.getInstance().getReplaceWord().then((_) {
      initialFetchMoments();
    });
  }


  @override
  void onClose() {
    _isDisposed = true;
    easyRefreshController.dispose();
    super.onClose();
  }

  Future<void> initialFetchMoments() async {
    isInitialLoading.value = true;
    hasError.value = false;
    try {
      await _fetchMomentsFromApi();
    } catch (e) {
      hasError.value = true;
      print('Error: $e');
    } finally {
      if (!_isDisposed) isInitialLoading.value = false;
    }
  }

  Future<void> fetchMoments({bool isRefresh = false}) async {
    if (_isDisposed || isLoading.value) return;

    if (isRefresh) {
      resetPagination();
    }

    isLoading.value = true;

    try {
      await _fetchMomentsFromApi();
    } catch (e) {
      handleError(e);
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  void resetPagination() {
    page = 1;
    moments.clear();
  }

  Future<void> _fetchMomentsFromApi() async {
    await dioClient.requestNetwork<List<dynamic>>(
      method: Method.get,
      url: ApiConstants.timelines,
      queryParameters: _getQueryParameters(),
      options: _getRequestOptions(),
      onSuccess: _handleSuccessResponse,
      onError: _handleErrorResponse,
    );
  }

  Map<String, dynamic> _getQueryParameters() {
    return {
      'page': page,
      'offset': pageOffset,
      //'filter[day]': 30,
      'filter[viewed]':1,
      //'filter[liked]': 1,
      //'collected':1
    };
  }

  Options _getRequestOptions() {
    return Options(
      headers: {
        'token': tokenEntity.accessToken,
      },
    );
  }

  void _handleSuccessResponse(List<dynamic>? data) {
    if (_isDisposed) return;
    if (data != null && data.isNotEmpty) {
      data = ReplaceWordUtil.getInstance().replaceWordsInJson(data) as List<dynamic>;

      List<MomentEntity> fetchedMoments = data
          .map((json) => MomentEntity.fromJson(json as Map<String, dynamic>))
          .toList();
      moments.addAll(fetchedMoments);
      page++;
      _finishLoadIfNotDisposed(noMore: false);
    } else {
      _finishLoadIfNotDisposed(noMore: true);
      if (moments.isEmpty) {
        _showNoDataDialog();
      }
    }
  }

  void _handleErrorResponse(int code, String msg, dynamic data) {
    print('Error: $msg');
    _finishLoadIfNotDisposed(noMore: true);
  }

  void handleError(dynamic error) {
    print('Error: $error');
    _finishLoadIfNotDisposed(noMore: true);
  }

  void _finishLoadIfNotDisposed({required bool noMore}) {
    if (!_isDisposed) easyRefreshController.finishLoad(noMore: noMore);
  }

  void _showNoDataDialog() {
    Get.dialog(
      CustomContentDialog(
        title: "No Data",
        content: "You haven't browsed other user interfaces and moments yet",
        buttonText: "OK",
        onButtonPressed: () => Get.back(),
      ),
    );
  }


  Future<void> refreshMoments() async {
    if (_isDisposed) return;
    isRefreshing.value = true;
    await fetchMoments(isRefresh: true);
    if (!_isDisposed) {
      easyRefreshController.finishRefresh();
      isRefreshing.value = false;
    }
  }
}
