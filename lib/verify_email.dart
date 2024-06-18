import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'verify_success.dart'; // 导入成功页面
import '../service/token_service.dart'; // 导入 token_service.dart

class VerifyEmail extends StatefulWidget {
  final String email;
  final String verificationKey; // 重命名 key 为 verificationKey

  VerifyEmail({required this.email, required this.verificationKey});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmail> {
  final TextEditingController _codeController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken; // 更改类型为 String?

  @override
  void initState() {
    super.initState();
    _initializeToken();

    // 打印 verificationKey
    print('Verification Key initialized: ${widget.verificationKey}');
    if (widget.verificationKey.isEmpty) {
      print('没有key');
    }
  }

  Future<void> _initializeToken() async {
    Map<String, String>? tokenData = await getToken();
    if (tokenData != null) {
      setState(() {
        _accessToken = tokenData['access_token']; // 存储 access token
        print('Token initialized: $_accessToken');
      });
    } else {
      setState(() {
        _errorMessage = "无法获取访问令牌。";
        print('Failed to initialize token');
      });
    }
  }

  Future<void> _verifyEmail() async {
    if (_accessToken == null) {
      setState(() {
        _errorMessage = "没有可用的访问令牌。";
        print('No access token available');
      });
      return;
    }

    final String email = widget.email;
    final String code = _codeController.text.trim();
    final String verificationKey = widget.verificationKey; // 使用重命名的 verificationKey

    // 打印 verificationKey
    print('Verification Key: $verificationKey');
    if (verificationKey.isEmpty) {
      print('没有key');
      setState(() {
        _errorMessage = "验证密钥为空。";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _dio.post(
        'https://api.masonvips.com/v1/verify_email',
        queryParameters: {
          'email': email,
          'code': code,
          'key': verificationKey,
        },
        options: Options(headers: {'token': _accessToken}),
      );

      if (response.data['code'] == 200 && response.data['data']['ret'] == true) {
        Get.to(() => VerifySuccess(message: response.data['message']));
      } else {
        setState(() {
          _errorMessage = "验证失败: ${response.data['message']}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "发生异常: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("验证邮箱")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "验证码已发送至 ${widget.email}。",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: "验证码",
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _verifyEmail,
              child: Text("验证"),
            ),
          ],
        ),
      ),
    );
  }
}
