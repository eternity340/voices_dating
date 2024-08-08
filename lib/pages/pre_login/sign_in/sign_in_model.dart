import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../../../constants/constant_data.dart';
import '../../../entity/user_data_entity.dart';
import '../../../service/app_service.dart';
import '../../../service/token_service.dart';
import '../../../entity/token_entity.dart';
import '../../../utils/shared_preference_util.dart';

class SignInModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _errorMessage;

  SignInModel() {
    _initializeToken();
  }

  bool get isLoading => _isLoading;
  String? get emailErrorMessage => _emailErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> _initializeToken() async {
    try {
      await TokenService.instance.getTokenEntity();
    } catch (e) {
      _errorMessage = "Failed to initialize token: $e";
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty) {
      _emailErrorMessage = "Email cannot be empty!";
      notifyListeners();
      return;
    } else {
      _emailErrorMessage = null;
    }

    if (password.isEmpty) {
      _passwordErrorMessage = "Password cannot be empty!";
      notifyListeners();
      return;
    } else {
      _passwordErrorMessage = null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();

      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      final formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      final response = await _dio.post(
        'https://api.masonvips.com/v1/signin',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (response.data[ConstantData.code] == 200) {
        final userDataJson = response.data['data'];

        if (userDataJson == null) {
          print('Error: User data is missing in the response.');
          throw Exception('User data is missing in the response.');
        }
        final userData = UserDataEntity.fromJson(userDataJson);
        print('User data: $userData');
        AppService.instance.isLogin = true;
        print(AppService.instance.isLogin);
        await SharedPreferenceUtil.instance.setValue(key: SharedPresKeys.isLogin, value: true);
        getx.Get.toNamed('/home', arguments: {
          'token': tokenEntity,
          'userData': userData,
        });
      } else if (response.data[ConstantData.code] == ConstantData.errorCodeInvalidEmailOrPassword) {
        _errorMessage = response.data[ConstantData.message];
        _showErrorDialog(_errorMessage);
      } else {
        _errorMessage = "error: ${response.data[ConstantData.message]}";
        _showErrorDialog(_errorMessage);
      }
    } catch (e) {
      _errorMessage = "exception: $e";
      print('Exception occurred: $_errorMessage');
      _showErrorDialog(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorDialog(String? message) {
    getx.Get.dialog(
      AlertDialog(
        title: const Text('Login Error'),
        content: Text(message ?? 'An unknown error occurred.'),
        actions: [
          TextButton(
            onPressed: () {
              getx.Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}