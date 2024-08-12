import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSend;

  const ChatInputBar({
    Key? key,
    required this.messageController,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x5CD4D7E0),
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
                // Handle voice button action here
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
                color: Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(24.5.w),
              ),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Send a message…",
                  filled: true,
                  fillColor: Colors.transparent,
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: Color(0xFF8E8E93),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                ),
              ),
            ),
          ),
          /*Positioned(
            left: 257.w,
            top: 15.h,
            child: IconButton(
              icon: Image.asset(
                'assets/images/icon_chat_emoji.png',
                width: 24.w,
                height: 24.h,
              ),
              onPressed: () {
                // Handle emoji button action here
              },
            ),
          ),*/
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
                // Handle photo button action here
              },
            ),
          ),
          Positioned(
            right: 20.w,
            top: 15.h,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.black),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
