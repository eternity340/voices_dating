// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
//
// class WebViewPage extends StatefulWidget {
//   final String? titleStr;
//   final String url;
//
//   const WebViewPage({Key? key, this.titleStr, this.url = 'https://google.com'})
//       : super(key: key);
//
//   @override
//   State<WebViewPage> createState() => _WebViewPageState();
// }
//
// class _WebViewPageState extends State<WebViewPage> {
//   final Completer<WebViewController> _controller =
//   Completer<WebViewController>();
//   bool isLoading = true;
//
//   late final PlatformWebViewControllerCreationParams params;
//   late final WebViewController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     controller = WebViewController.fromPlatformCreationParams(params);
//
//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {
//             LogUtil.d(message: 'Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             LogUtil.d(message: 'Page finished loading: $url');
//             setState(() {
//               isLoading = false;
//             });
//           },
//           onWebResourceError: (error) {
//             setState(() {
//               isLoading = false;
//             });
//             LogUtil.d(message: "loading fail: $error");
//             WfCommonUtils.showToast(message:error.description);
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("url=${widget.url}");
//     return WfCustomScaffold(
//       backgroundColor: AppStyleUtils.bgGroundColor,
//       appBar: WfCustomAppBar(
//         titleStr: widget.titleStr ?? "", context: context,
//       ),
//       body: Stack(children: [
//         WebViewWidget(controller: controller),
//         isLoading
//             ? const Center(
//           child: CircularProgressIndicator(),
//         )
//             : const SizedBox(),
//       ]),
//     );
//   }
// }
