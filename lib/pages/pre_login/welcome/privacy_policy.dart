import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/components/background.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../constants/constant_data.dart';
import '../../../utils/common_utils.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool isLoading = true;

  late final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          if (progress == 100) {
            setState(() {
              isLoading = false;
            });
          }
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          setState(() {
            isLoading = false;
          });
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://www.voicesdating.com/PPSA/PrivacyPolicy.html'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        showMiddleText: true,
        showBackButton: true,
        middleText: ConstantData.serviceAgreement,
        child: Stack(
          children: [
            Positioned(
              top: 50.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: WebViewWidget(controller: controller),
            ),
            if (isLoading)
              Positioned.fill(
                child: CommonUtils.loadingIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
