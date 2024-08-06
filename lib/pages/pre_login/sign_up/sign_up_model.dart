import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../../../constants/constant_data.dart';
import '../../../entity/User.dart';
import '../../../entity/token_entity.dart';
import '../../../service/token_service.dart';

class SignUpModel extends ChangeNotifier {
  User user = User();
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _emailErrorMessage;
  String? _usernameErrorMessage;
  String? _passwordErrorMessage;
  String? _errorMessage;

  SignUpModel() {
    _initializeToken();
  }

  bool get isLoading => _isLoading;
  String? get emailErrorMessage => _emailErrorMessage;
  String? get usernameErrorMessage => _usernameErrorMessage;
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

  void setEmail(String email) {
    user.email = email;
    _emailErrorMessage = null;
    notifyListeners();
  }

  void setUsername(String username) {
    user.username = username;
    _usernameErrorMessage = null;
    notifyListeners();
  }

  void setPassword(String password) {
    user.password = password;
    _passwordErrorMessage = null;
    notifyListeners();
  }

  void setBirthday(DateTime birthday) {
    user.birthday = birthday;
    notifyListeners();
  }

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> signUp() async {
    if (user.email == null || user.email!.isEmpty) {
      _emailErrorMessage = "Email cannot be empty!";
      notifyListeners();
      return;
    }
    if (user.username == null || user.username!.isEmpty) {
      _usernameErrorMessage = "Username cannot be empty!";
      notifyListeners();
      return;
    }
    if (user.password == null || user.password!.isEmpty) {
      _passwordErrorMessage = "Password cannot be empty!";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final TokenEntity tokenEntity = await TokenService.instance.getTokenEntity();

      if (tokenEntity.accessToken == null) {
        throw Exception("No access token available");
      }

      final formData = FormData.fromMap(user.toJson());

      final response = await _dio.post(
        'https://api.masonvips.com/v1/signup',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (ConstantData.successResponseCode.contains(response.data[ConstantData.code])) {
        getx.Get.toNamed('/welcome', arguments: user);
      } else {
        _errorMessage = response.data[ConstantData.message];
        _showErrorDialog(_errorMessage);
      }
    } catch (e) {
      _errorMessage = "exception: $e";
      _showErrorDialog(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorDialog(String? message) {
    getx.Get.dialog(
      AlertDialog(
        title: const Text('Sign Up Error'),
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