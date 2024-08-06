import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../utils/log_util.dart';
import 'package:first_app/components/background.dart';
import '../../components/all_navigation_bar.dart';
import '../../entity/chatted_user_entity.dart';
import '../../image_res/image_res.dart';
import '../../net/dio.client.dart';
import 'components/message_content.dart';

class MessagePage extends StatefulWidget {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userData'] as UserDataEntity;

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  List<ChattedUserEntity> chattedUsers = [];

  @override
  void initState() {
    super.initState();
    fetchChattedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: false,
            showBackgroundImage: true,
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 67.h),
            child: Row(
              children: [
                _buildOption(ConstantData.messageText, 0),
                SizedBox(width: 50.w),
                _buildOption(ConstantData.viewedMeText, 1),
                SizedBox(width: 50.w),
                _buildOption(ConstantData.likedMeText, 2),
              ],
            ),
          ),
          Positioned(
            top: 139.h,
            left: (ScreenUtil().screenWidth - 335.w) / 2,
            child: Container(
              width: 335.w,
              height: 680.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(24.r),
                backgroundBlendMode: BlendMode.srcOver,
              ),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  MessageContent(
                    chattedUsers: chattedUsers,
                    onRefresh: fetchChattedUsers,
                  ),
                  Center(child: Text('Content for Viewed Me')),
                  Center(child: Text('Content for Liked Me')),
                ],
              ),
            ),
          ),
          AllNavigationBar(tokenEntity: widget.tokenEntity, userData: widget.userData),
        ],
      ),
    );
  }

  Widget _buildOption(String text, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isSelected)
            Positioned(
              right: 0.w,
              top: 0.h,
              child: Image.asset(
                ImageRes.imagePathDecorate,
                width: 17.w,
                height: 17.h,
              ),
            ),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              fontSize: isSelected ? 18.sp : 16.sp,
              height: 1.5,
              letterSpacing: -0.01,
              color: isSelected ? Colors.black : Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchChattedUsers() async {
    try {
      DioClient dioClient = DioClient();
      dioClient.init(options: BaseOptions(
        headers: {
          'token': widget.tokenEntity.accessToken,
        },
      ));
      dioClient.requestNetwork<List<ChattedUserEntity>>(
        method: Method.get,
        url: ApiConstants.chattedUsers,
        onSuccess: (data) {
          setState(() {
            chattedUsers = data!;
          });
        },
        onError: (code, msg, data) {
          LogUtil.e(message: 'Fetch error: $msg');
        },
      );
    } catch (e) {
      LogUtil.e(message: 'Fetch error: $e');
    }
  }
}
