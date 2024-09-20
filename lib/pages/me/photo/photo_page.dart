import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:common_utils/common_utils.dart';
import 'package:voices_dating/constants/constant_styles.dart';
import 'package:voices_dating/pages/me/photo/photo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../components/background.dart';
import '../../../components/bottom_options.dart';
import '../../../constants/constant_data.dart';
import '../../../image_res/image_res.dart';

class PhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PhotoController controller = Get.put(PhotoController());

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        controller.navigateToMePage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Background(
              showBackgroundImage: false,
              showMiddleText: true,
              middleText: ConstantData.photoTitle,
              child: GetBuilder<PhotoController>(
                builder: (controller) {
                  return Column(
                    children: [
                      SizedBox(height: 60.h),
                      Expanded(
                        child: EasyRefresh(
                          onRefresh: controller.fetchUserData,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildAddPhotoContainer(context, controller),
                                      buildMainPhotoContainer(controller),
                                    ],
                                  ),
                                ),
                                buildPhotoContainers(controller),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 50.h,
              child: Container(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddPhotoContainer(BuildContext context, PhotoController controller) {
    return GestureDetector(
      onTap: () {
        if (controller.tokenEntity.accessToken != null) {
          showOptions(context, controller.tokenEntity.accessToken!, controller);
        } else {
          LogUtil.e(ConstantData.errorTokenInvalid);
        }
      },
      child: Container(
        width: 137.09.w,
        height: 174.h,
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Container(
            width: 38.4.w,
            height: 38.4.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageRes.imagePathIconAddPhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMainPhotoContainer(PhotoController controller) {
    if (controller.userData.photos == null || controller.userData.photos!.isEmpty) {
      // 如果没有主照片，显示加载状态
      if (controller.uploadingPhotos.isNotEmpty) {
        return Container(
          width: 137.09.w,
          height: 174.h,
          decoration: BoxDecoration(
            color: Color(0xFFF8F8F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        // 如果没有上传中的照片，显示 "haven't main Photo"
        return Container(
          width: 137.09.w,
          height: 174.h,
          decoration: BoxDecoration(
            color: Color(0xFFF8F8F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              "haven't main Photo",
              style: ConstantStyles.lastActiveTimeStyle,
            ),
          ),
        );
      }
    }

    final mainPhoto = controller.userData.photos![0];

    return GestureDetector(
      onTap: () {
        controller.showPhotoDialog(mainPhoto.url!, mainPhoto.attachId!);
      },
      child: Container(
        width: 137.09.w,
        height: 174.h,
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                mainPhoto.url!,
                fit: BoxFit.cover,
                width: 137.09.w,
                height: 174.h,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 137.09.w,
                height: 34.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFABFFCF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    ConstantData.mainPhotoText,
                    style: ConstantStyles.mainPhotoTextStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhotoContainers(PhotoController controller) {
    List<Widget> photoWidgets = [];

    // 添加已上传的图片
    if (controller.userData.photos != null && controller.userData.photos!.length > 1) {
      for (int i = 1; i < controller.userData.photos!.length; i++) {
        final photo = controller.userData.photos![i];
        photoWidgets.add(
          GestureDetector(
            onTap: () {
              controller.showPhotoDialog(photo.url!, photo.attachId!);
            },
            child: _buildPhotoContainer(
              imageProvider: NetworkImage(photo.url!),
              isUploading: false,
            ),
          ),
        );
      }
    }

    // 添加正在上传的本地图片
    if (controller.userData.photos != null && controller.userData.photos!.isNotEmpty) {
      controller.uploadingPhotos.forEach((localPath, isUploading) {
        photoWidgets.add(
          _buildPhotoContainer(
            imageProvider: FileImage(File(localPath)),
            isUploading: true,
          ),
        );
      });
    }

    if (photoWidgets.isEmpty) {
      return SizedBox.shrink();
    }

    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
      crossAxisCount: 2,
      childAspectRatio: 137.09 / 174,
      crossAxisSpacing: 24.w,
      mainAxisSpacing: 24.h,
      children: photoWidgets,
    );
  }

  Widget _buildPhotoContainer({required ImageProvider imageProvider, required bool isUploading}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
          if (isUploading)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showOptions(BuildContext context, String accessToken, PhotoController controller) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomOptions(
          onFirstPressed: () async {
            if (await controller.requestPermission(Permission.camera)) {
              await controller.pickAndUploadPhoto(accessToken, ImageSource.camera);
            }
            Navigator.pop(context);
          },
          onSecondPressed: () async {
            if (await controller.requestPermission(Permission.photos)) {
              await controller.pickAndUploadPhoto(accessToken, ImageSource.gallery);
            }
            Navigator.pop(context);
          },
          onCancelPressed: () {
            Navigator.pop(context);
          },
          firstText: ConstantData.takePhotoText,
          secondText: ConstantData.fromAlbumText,
        );
      },
    );
  }
}
