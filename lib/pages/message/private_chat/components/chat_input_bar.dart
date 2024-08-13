import 'package:dio/dio.dart';
import 'package:first_app/entity/chatted_user_entity.dart';
import 'package:first_app/entity/token_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../../../components/bottom_options.dart';
import '../../../../service/im_service.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final TokenEntity tokenEntity;
  final ChattedUserEntity chattedUserEntity;

  const ChatInputBar({
    super.key,
    required this.textController,
    required this.onSend,
    required this.tokenEntity,
    required this.chattedUserEntity,
  });

  Future<void> _pickAndUploadPhoto(BuildContext context, ImageSource source) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Permission permission = source == ImageSource.camera ? Permission.camera : Permission.photos;

    // 检查和请求权限
    if (await permission.request().isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        var localId = const Uuid().v4().toString();
        var success = await _uploadImage(image, localId);
        if (success) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Image sent successfully')),
          );
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Failed to send image')),
          );
        }
      }
    } else {
      // 权限被拒绝，显示消息
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Permission denied')),
      );
    }
  }

  Future<bool> _uploadImage(XFile image, String localId) async {
    try {
      var dio = Dio();
      var response = await dio.post(
        'https://api.masonvips.com/v1/upload_file',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        }),
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if ( response.data['code'] == 200) {
        var attachId = response.data['data'][0]['attachId'].toString();
        var imageUrl = response.data['data'][0]['url'].toString();
        var receiverId = chattedUserEntity.userId;

        // 发送图像
        return await IMService().sendImage(
          attachId: attachId,
          imageUrl: imageUrl,
          receiverId: receiverId.toString(),
          localId: localId,
        );
      }
      return false;
    } catch (e) {
      debugPrint('Upload failed: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x5CD4D7E0),
            blurRadius: 89.76.sp,
            offset: Offset(0, -20.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10.w,
            top: 15.5.h,
            child: IconButton(
              icon: Image.asset(
                'assets/images/icon_chat_voice.png',
                width: 18.w,
                height: 18.h,
              ),
              onPressed: () {
                // 处理语音按钮操作
              },
            ),
          ),
          Positioned(
            left: 70.w,
            top: 12.h,
            child: Container(
              width: 185.w,
              height: 49.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(24.5.w),
              ),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Send a message…",
                  filled: true,
                  fillColor: Colors.transparent,
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: const Color(0xFF8E8E93),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                ),
              ),
            ),
          ),
          Positioned(
            left: 270.w,
            top: 15.h,
            child: IconButton(
              icon: Image.asset(
                'assets/images/icon_chat_photo.png',
                width: 24.w,
                height: 24.h,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => BottomOptions(
                    onFirstPressed: () async {
                      await _pickAndUploadPhoto(context, ImageSource.camera);
                      Navigator.pop(context);
                    },
                    onSecondPressed: () async {
                      await _pickAndUploadPhoto(context, ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    onCancelPressed: () {
                      Navigator.pop(context);
                    },
                    firstText: 'Take Photo',
                    secondText: 'From Album',
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 20.w,
            top: 15.h,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
