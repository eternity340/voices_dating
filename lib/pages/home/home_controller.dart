import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../entity/list_user_entity.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';

class HomeController extends GetxController {
  var selectedOption = 'Honey'.obs;
  late PageController pageController;
  var users = <ListUserEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxnString();
  final TokenEntity tokenEntity;
  final UserDataEntity? _userData;
  var currentPage = 1;
  var hasMoreData = true.obs;

  HomeController(this.tokenEntity, this._userData) {
    pageController = PageController(initialPage: 0);
    fetchUsers();
  }

  void selectOption(String option) {
    selectedOption.value = option;
    int pageIndex = (option == 'Honey') ? 0 : 1;
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int index) {
    selectedOption.value = index == 0 ? 'Honey' : 'Nearby';
  }

  Future<void> fetchUsers() async {
    if (isLoading.value || !hasMoreData.value) return;
    _setLoading(true);
    final Dio dio = Dio();
    const String url = 'https://api.masonvips.com/v1/search';

    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'page': currentPage,
          'offset': 20,
          'find[gender]': 2,
        },
        options: Options(headers: {'token': tokenEntity.accessToken}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'] as List<dynamic>;
        List<ListUserEntity> newUsers = jsonList.map((json) => ListUserEntity.fromJson(json)).toList();

        if (newUsers.isEmpty) {
          hasMoreData.value = false;
        } else {
          users.addAll(newUsers);
          currentPage++;
        }
      } else {
        throw Exception('Failed to load users');
      }
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
}

