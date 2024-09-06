import 'package:common_utils/common_utils.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../constants/constant_data.dart';
import '../../../../image_res/image_res.dart';

class CustomRecaptchaWidget extends StatefulWidget {
  final String apiKey;

  final Function(String token) tokenHandler;

  CustomRecaptchaWidget({required this.apiKey, required this.tokenHandler});

  @override
  State<StatefulWidget> createState() => _CustomRecaptchaState();
}

class _CustomRecaptchaState extends State<CustomRecaptchaWidget> {
  WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.transparent);

  double dlgHeight = 480;
  bool isValidate = false;
  bool isLoading = false;
  bool isWebloaded = false;

  @override
  void initState() {
    super.initState();
    loadLocal();
  }

  @override
  void didUpdateWidget(CustomRecaptchaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadLocal() async {
    String path = await rootBundle.loadString(ConstantData.googleRecaptcha);
    path = path.replaceFirst("apiKey", widget.apiKey);
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'RecaptchaFlutterChannel',
        onMessageReceived: (JavaScriptMessage receiver) {
          String _token = receiver.message;
          if (_token.contains("verify")) {
            _token = _token.substring(7);
          }
          widget.tokenHandler(_token);
        },
      )
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            webViewController.runJavaScript("execute()");
            LogUtil.v("execute!!!");
            LogUtil.e(url);
          },
          onWebResourceError: (WebResourceError error) {
            LogUtil.e(error);
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(path, baseUrl: ApiConstants.debugUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: dlgHeight,
        alignment: Alignment.center,
        child: Stack(
          children: [
            WebViewWidget(
              controller: webViewController,
            )
          ],
        ),
      ),
    );
  }
}
