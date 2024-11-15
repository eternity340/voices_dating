import 'package:dio/dio.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../constants/constant_data.dart';
import '../../entity/list_user_entity.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';
import '../../net/dio.client.dart';
import '../../service/app_service.dart';
import '../../utils/event_bus.dart';
import '../../utils/replace_word_util.dart';

class HomeController extends GetxController {
  var selectedOption = 'Honey'.obs;
  late PageController pageController;
  var users = <ListUserEntity>[].obs;
  var nearUsers = <ListUserEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxnString();
  final TokenEntity tokenEntity;
  var honeyCurrentPage = 1;
  var nearbyCurrentPage = 1;
  var hasMoreData = true.obs;
  final Rx<UserDataEntity?> rxUserData = Rx<UserDataEntity?>(null);

  var isInitialHoneyLoading = true.obs;
  var isInitialNearbyLoading = true.obs;

  UserDataEntity? get userData => AppService.instance.selfUser;

  @override
  void onInit() {
    super.onInit();
    EventBus().onUserReported.listen((userId) {
      removeUser(userId);
    });
  }

  HomeController(this.tokenEntity) {
    pageController = PageController(initialPage: 0);
    // fetchUsers();
    // fetchNearUsers();
    fetchInitialUsers();
    //_initUserData();
  }

  Future<void> fetchInitialUsers() async {
    await fetchUsers(isInitial: true);
    isInitialHoneyLoading.value = false;
  }


  void _initUserData() {
    rxUserData.value = AppService.instance.rxSelfUser.value;
    ever(AppService.instance.rxSelfUser, (userData) {
      rxUserData.value = userData;
    });
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
        : ConstantData.nearbyOption;
    if (index == 1) {
      loadNearbyUsersIfNeeded();
    }
  }

  Future<void> fetchUsers({bool isInitial = false}) async {
    if (!isInitial && (isLoading.value || !hasMoreData.value)) return;
    _setLoading(true);
    try {
      await DioClient.instance.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: ApiConstants.search,
        queryParameters: {
          'page': honeyCurrentPage,
          'offset': 20,
        },
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null && data.isNotEmpty) {
            ReplaceWordUtil replaceWordUtil = ReplaceWordUtil.getInstance();
            replaceWordUtil.getReplaceWord();
            List<ListUserEntity> processedUsers = data.map((user) {
              Map<String, dynamic> userMap = Map<String, dynamic>.from(user);
              var processedUser = replaceWordUtil.replaceWordsInJson(userMap);
              return ListUserEntity.fromJson(processedUser);
            }).toList();

            users.addAll(processedUsers);
            honeyCurrentPage++;
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


  Future<void> fetchNearUsers({bool isInitial = false}) async {
    if (!isInitial && (isLoading.value || !hasMoreData.value)) return;
    _setLoading(true);
    try {
      await DioClient.instance.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: ApiConstants.search,
        queryParameters: {
          'page': nearbyCurrentPage,
          'offset': 20,
          'find[distance]':'300'
        },
        options: Options(headers: {'token': tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null && data.isNotEmpty) {
            ReplaceWordUtil replaceWordUtil = ReplaceWordUtil.getInstance();
            replaceWordUtil.getReplaceWord();

            List<ListUserEntity> processedUsers = data.map((user) {
              Map<String, dynamic> userMap = Map<String, dynamic>.from(user);
              var processedUser = replaceWordUtil.replaceWordsInJson(userMap);
              return ListUserEntity.fromJson(processedUser);
            }).toList();

            nearUsers.addAll(processedUsers);
            nearbyCurrentPage++;
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
      if (isInitial) {
        isInitialNearbyLoading.value = false;
      }
    }
  }


  void loadNearbyUsersIfNeeded() {
    if (nearUsers.isEmpty) {
      fetchNearUsers(isInitial: true);
    }
  }

  void _setLoading(bool value) {
    isLoading.value = value;
  }

  void _setErrorMessage(String value) {
    errorMessage.value = value;
  }

  void navigateToFeelPage() {
    if (userData != null) {
      Get.toNamed(AppRoutes.homeFeel,
          arguments: {'tokenEntity': tokenEntity});
    }
  }

  void navigateToGetUpPage() {
    if (userData != null) {
      Get.toNamed(AppRoutes.homeViewed,
          arguments: {
            'token': tokenEntity,
            'userData': userData});
    }
  }

  void navigateToGamePage() {
    if (userData != null) {
      Get.toNamed(AppRoutes.homeGame,
          arguments: {'tokenEntity': tokenEntity});
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

  void navigateToFiltersPage() {
    if (userData != null) {
      Get.toNamed(AppRoutes.homeFilters,
          arguments: {'tokenEntity': tokenEntity});
    }
  }

  void removeUser(String userId) {
    users.removeWhere((user) => user.userId == userId);
    nearUsers.removeWhere((user) => user.userId == userId);
    update(); // 通知 UI 更新
  }
}