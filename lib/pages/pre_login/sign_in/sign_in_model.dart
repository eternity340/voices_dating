import 'package:voices_dating/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../../../components/custom_content_dialog.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/app_service.dart';

class SignInModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DioClient _dioClient = DioClient();
  bool _isLoading = false;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  bool get isLoading => _isLoading;
  String? get emailErrorMessage => _emailErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> signIn() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (!_validateInputs(email, password)) return;

    _setLoadingState(true);

    final Map<String, dynamic> params = {
      'email': email,
      'password': password,
    };

    await _dioClient.requestNetwork<UserDataEntity>(
      method: Method.post,
      url: ApiConstants.signIn,
      params: params,  // 直接传入 FormData 对象
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
      formParams: false,  // 设置为 false，因为我们已经创建了 FormData
      onSuccess: (data) async {
        if (data != null) {
          await AppService.instance.saveUserData(userData: data);
          getx.Get.offAllNamed('/home');
        } else {
          _handleError("User data is missing in the response.");
        }
      },
      onError: (code, msg, data) {
        if (code == ConstantData.errorCodeInvalidEmailOrPassword) {
          _handleError(msg);
        } else {
          _handleError("Error: $msg");
        }
      },
    );

    _setLoadingState(false);
  }

  bool _validateInputs(String email, String password) {
    if (email.isEmpty) {
      _emailErrorMessage = "Email cannot be empty!";
      notifyListeners();
      return false;
    }
    _emailErrorMessage = null;

    if (password.isEmpty) {
      _passwordErrorMessage = "Password cannot be empty!";
      notifyListeners();
      return false;
    }
    _passwordErrorMessage = null;

    return true;
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    _errorMessage = null;
    notifyListeners();
  }

  void _handleError(String errorMessage) {
    _errorMessage = errorMessage;
    print(_errorMessage);
    _showErrorDialog(_errorMessage);
  }

  void _showErrorDialog(String? message) {
    getx.Get.dialog(
      CustomContentDialog(
        title: 'Login Error',
        content: message ?? 'An unknown error occurred.',
        buttonText: 'OK',
        onButtonPressed: () {
          getx.Get.back();
        },
      ),
    );
  }
}
