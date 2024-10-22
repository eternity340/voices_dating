import 'package:voices_dating/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:voices_dating/routes/app_routes.dart';
import '../../../components/custom_content_dialog.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/user_data_entity.dart';
import '../../../net/dio.client.dart';
import '../../../service/app_service.dart';
import '../../../service/im_service.dart';

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
      params: params,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
      formParams: false,
      onSuccess: (data) async {
        if (data != null) {
          await AppService.instance.saveUserData(userData: data);
          IMService.instance.connect();
          getx.Get.offAllNamed('/home');
        } else {
          _showErrorDialog("User data is missing in the response.");
        }
      },
      onError: (code, msg, data) {
        if (code == 30001055) {
          _showSuspendedDialog();
        } else if (code == ConstantData.errorCodeInvalidEmailOrPassword) {
          print(msg); // 打印 message
          _showErrorDialog(msg);
        } else {
          _showErrorDialog("Error: $msg");
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
    notifyListeners();
  }

  void _showSuspendedDialog() {
    getx.Get.dialog(
      CustomContentDialog(
        title: 'Login Failed',
        content: 'Your account has been suspended due to possible violations.',
        buttonText: 'Details',
        onButtonPressed: () {
          //getx.Get.back();
          getx.Get.toNamed(AppRoutes.accountSuspended);
        },
      ),
    );
  }

  void _showErrorDialog(String message) {
    getx.Get.dialog(
      CustomContentDialog(
        title: 'Login Failed',
        content: message,
        buttonText: 'OK',
        onButtonPressed: () => getx.Get.back(),
      ),
    );
  }
}
