import 'package:dio/dio.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:first_app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../constants/constant_data.dart';
import '../../entity/list_user_entity.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';
import '../../net/dio.client.dart';
import '../../service/app_service.dart';

class HomeController extends GetxController {
  var selectedOption = 'Honey'.obs;
  late PageController pageController;
  var users = <ListUserEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxnString();
  final TokenEntity tokenEntity;
  var currentPage = 1;
  var hasMoreData = true.obs;

  HomeController(this.tokenEntity) {
    pageController = PageController(initialPage: 0);
    fetchUsers();
  }

  void selectOption(String option) {
    selectedOption.value = option;
    int pageIndex = (option == 'Honey') ? 0 : 1;
    pageController.animateToPage(
        pageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  void onPageChanged(int index) {
    selectedOption.value = index == 0
        ? ConstantData.honeyOption
        : ConstantData.nearbyOption
    ;}

  Future<void> fetchUsers() async {
    if (isLoading.value || !hasMoreData.value) return;
    _setLoading(true);
    try {
      DioClient.instance.requestNetwork<List<ListUserEntity>>(
        method: Method.get,
        url: ApiConstants.search,
        queryParameters: {
          'page': currentPage,
          'offset': 20,
          'find[gender]': 2,
        },
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null && data.isNotEmpty) {
            users.addAll(data);
            currentPage++;
          } else {
            hasMoreData.value = false;
          }
        },
        onError: (code, msg, data) {
          _setErrorMessage(msg);
        },
      );
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading.value = value;
  }

  void _setErrorMessage(String value) {
    errorMessage.value = value;
  }

  UserDataEntity? get userData => AppService.instance.rxSelfUser.value;

  void navigateToFeelPage() {
    if (userData != null) {
      Get.toNamed(AppRoutes.homeFeel,
          arguments: {
            'token': tokenEntity,
            'userData': userData});
    }
  }

  void navigateToGetUpPage() {
    if (userData != null) {
      Get.toNamed(AppRoutes.homeGetUp,
          arguments: {
            'token': tokenEntity,
            'userData': userData});
    }
  }

  void navigateToGamePage() {
    if (userData != null) {
      Get.toNamed(AppRoutes.homeGame,
          arguments: {
            'token': tokenEntity,
            'userData': userData});
    }
  }

  void navigateToGossipPage() {
    if (userData != null) {
      Get.toNamed(AppRoutes.homeGossip,
          arguments: {
            'token': tokenEntity,
            'userData': userData});
    }
  }
}