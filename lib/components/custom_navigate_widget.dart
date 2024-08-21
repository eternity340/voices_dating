// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../image_res/image_res.dart';
// import '../net/api_constants.dart';
// import '../resources/string_res.dart';
// import '../utils/app_style_utils.dart';
// import '../utils/local_image_util.dart';
// import 'app_space.dart';
// import 'bottom_button.dart';
//
//
// class CustomNavigateWidget extends StatelessWidget {
//   final VoidCallback onConfirmTap;
//   final int gender;
//
//   const CustomNavigateWidget(
//       {super.key, required this.onConfirmTap, required this.gender});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 36.w, vertical: 160.h),
//       padding: EdgeInsets.symmetric(horizontal: 29.w),
//       decoration: BoxDecoration(
//         color: AppStyleUtils.bgGroundColor,
//         border: Border.all(width: 2.w, color: Colors.black),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             ColumnSpace(height: 25.h),
//             Align(
//               alignment: Alignment.topRight,
//               child: GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: LocalImageUtil.getAssetImage(
//                     imageName: ImageRes.iconCancel,
//                     width: 20.w,
//                     height: 20.w),
//               ),
//             ),
//             ColumnSpace(height: 15.h),
//             Text(
//               StringRes.getString(StringRes.navigateTip),
//               style: AppStyleUtils.titleStyles.copyWith(fontSize: 16.sp),
//               textAlign: TextAlign.center,
//             ),
//             ColumnSpace(height: 49.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 109.w,
//                   height: 109.w,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: LocalImageUtil.getAssetImageProvider(
//                           imageName: ImageRes.placeholderAvatar,
//                           width: 109.w,
//                           height: 109.w,
//                           boxFit: BoxFit.fill
//                       ),
//                     ),
//                     borderRadius: BorderRadius.circular(16.r),
//                   ),
//                 ),
//                 Container(
//                   width: 109.w,
//                   height: 109.w,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: LocalImageUtil.getAssetImageProvider(
//                         imageName: ImageRes.placeholderAvatar,
//                         width: 109.w,
//                         height: 109.w,
//                       ),
//                     ),
//                     borderRadius: BorderRadius.circular(16.r),
//                   ),
//                 ),
//               ],
//             ),
//             ColumnSpace(height: 52.h),
//             BottomButton(
//               onButtonPress: () {
//                 onConfirmTap();
//               },
//               label: StringRes.getString(StringRes.getMoreMatch),
//               borderSide: BorderSide(width: 1.w, color: Colors.black),
//               color: AppStyleUtils.itemSelectedColor,
//               width: 230.w,
//               height: 36.h,
//               radius: 12.r,
//             ),
//             ColumnSpace(height: 20.h),
//             RichText(
//               textAlign: TextAlign.center,
//               text:  TextSpan(
//                   children: [
//                     TextSpan(
//                         text:StringRes.getString(StringRes.clickYesToNaviPre),style: AppStyleUtils.subLabelStyles.copyWith(color:const Color(0xff333333),fontFamily: "Hind",fontSize: 13.sp)
//                     ),
//                     TextSpan(
//                       text: StringRes.getString(StringRes.termsOfUse),
//                       style: AppStyleUtils.subLabelStyles.copyWith(color: const Color(0xff333333),decoration: TextDecoration.underline,fontFamily: "Hind",fontSize: 13.sp),
//                       recognizer: TapGestureRecognizer()..onTap=(){
//                         Get.to(WebViewPage(titleStr: StringRes.getString(StringRes.termsOfUse),url: ApiConstants.getTnc(showMain: true),));
//                       },
//                     ),
//                     TextSpan(text: " ${StringRes.getString(StringRes.and)} ",style: AppStyleUtils.subLabelStyles.copyWith(color: const Color(0xff333333),fontFamily: "Hind",fontSize: 13.sp)),
//                     TextSpan(
//                         text: StringRes.getString(StringRes.privacyPolicy),
//                         style: AppStyleUtils.subLabelStyles.copyWith(color: const Color(0xff333333),decoration: TextDecoration.underline,fontFamily: "Hind",fontSize: 13.sp),
//                         recognizer: TapGestureRecognizer()..onTap=(){
//                           Get.to(WebViewPage(titleStr: StringRes.getString(StringRes.privacyPolicy),url: ApiConstants.getPrivacy(showMain: true),));
//                         }
//                     ),
//                   ]
//               ),
//
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
