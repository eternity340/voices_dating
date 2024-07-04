import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart'; // 导入 TokenEntity

class HomeController extends ChangeNotifier {
  String selectedOption = 'Honey';
  late PageController pageController;
  late ScrollController scrollController;
  List<ListUserEntity> users = [];
  bool isLoading = false;
  String? errorMessage;
  TokenEntity? _tokenEntity; // 使用 TokenEntity 类型
  int currentPage = 1;
  bool hasMoreData = true;

  HomeController(this._tokenEntity) {
    pageController = PageController(initialPage: 0);
    scrollController = ScrollController();
    fetchUsers(); // Automatically fetch users when token is initialized
    scrollController.addListener(_scrollListener);
  }

  void selectOption(String option) {
    selectedOption = option;
    int pageIndex = (option == 'Honey') ? 0 : 1;
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
    notifyListeners();
  }

  void onPageChanged(int index) {
    selectedOption = index == 0 ? 'Honey' : 'Nearby';
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    if (isLoading || !hasMoreData) return;

    _setLoading(true);

    final Dio dio = Dio();
    const String url = 'https://api.masonvips.com/v1/search';

    try {
      final response = await dio.get(url, queryParameters: {'page': currentPage}, options: Options(headers: {'token': _tokenEntity?.accessToken}));
      if (response.statusCode == 200) {
        print(response.data); // Print raw response to debug
        final List<dynamic> jsonList = response.data['data'] as List<dynamic>;
        List<ListUserEntity> newUsers = jsonList.map((json) => ListUserEntity.fromJson(json)).toList();
        if (newUsers.isEmpty) {
          hasMoreData = false;
        } else {
          users.addAll(newUsers);
          for (var user in newUsers) {
            print(user.photos); // Print photos of each user
          }
          currentPage++;
        }
      } else {
        _setErrorMessage("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      _setErrorMessage("Error fetching users: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      fetchUsers();
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
