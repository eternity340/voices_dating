import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../entity/list_user_entity.dart';

class HomeController extends ChangeNotifier {
  String selectedOption = 'Honey';
  late PageController pageController;
  late ScrollController scrollController;
  List<ListUserEntity> users = [];
  bool isLoading = false;
  String? errorMessage;
  late String _accessToken;
  int currentPage = 1;
  bool hasMoreData = true;

  HomeController(this._accessToken) {
    pageController = PageController(initialPage: 0);
    scrollController = ScrollController();
    fetchUsers(); // Automatically fetch users when token is initialized
    scrollController.addListener(_scrollListener);
  }

  void selectOption(String option) {
    selectedOption = option;
    if (option == 'Honey') {
      pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    notifyListeners();
  }

  void onPageChanged(int index) {
    selectedOption = index == 0 ? 'Honey' : 'Nearby';
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final Dio dio = Dio();
    const String url = 'https://api.masonvips.com/v1/search';

    try {
      final response = await dio.get(url, queryParameters: {'page': currentPage}, options: Options(headers: {'token': _accessToken}));
      if (response.statusCode == 200) {
        print(response.data); // Print raw response to debug
        final List<dynamic> jsonList = response.data['data'] as List<dynamic>;
        List<ListUserEntity> newUsers = jsonList.map((json) => ListUserEntity.fromJson(json)).toList();
        if (newUsers.isEmpty) {
          hasMoreData = false;
        } else {
          users.addAll(newUsers);
          currentPage++;
        }
      } else {
        errorMessage = "Failed to fetch users: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Error fetching users: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      fetchUsers();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
