import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as getX;
import '../../components/all_navigation_bar.dart';
import '../../../entity/token_entity.dart';
import '../../components/background.dart';
import '../../entity/moment_entity.dart';
import '../../entity/user_data_entity.dart';
import 'components/moments_card.dart';

class MomentsPage extends StatefulWidget {
  @override
  _MomentsPageState createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;
  List<MomentEntity> _moments = [];

  @override
  void initState() {
    super.initState();
    tokenEntity = getX.Get.arguments['token'] as TokenEntity;
    userData = getX.Get.arguments['userData'] as UserDataEntity;
    _fetchMoments();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: false,
            child: Container(),
          ),
          Positioned(
            left: 16.w,
            top: 67.h,
            child: Text(
              'Moments',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                color: Color(0xFF000000),
              ),
            ),
          ),
          Positioned(
            left: 315.w,
            top: 59.5.h,
            child: GestureDetector(
              onTap: () {
                // 添加点击事件处理
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/button_round_search.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 109.h,
            child: Container(
              width: 335.w,
              height: 650.h, // 修改高度以适应更多内容
              child: ListView.builder(
                itemCount: _moments.length,
                itemBuilder: (context, index) {
                  return MomentsCard(moment: _moments[index]);
                },
              ),
            ),
          ),
          AllNavigationBar(tokenEntity: tokenEntity, userData: userData),
        ],
      ),
    );
  }

  Future<void> _fetchMoments() async {
    try {
      dio.Dio dioInstance = dio.Dio();
      dio.Response response = await dioInstance.get(
        'https://api.masonvips.com/v1/timelines',
        queryParameters: {
          //'profId': userData.userId,
        },
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> momentsJson = response.data['data'];
        List<MomentEntity> moments = momentsJson
            .map((json) => MomentEntity.fromJson(json as Map<String, dynamic>))
            .toList();
        setState(() {
          _moments = moments;
        });
      } else {
        print('Failed to load moments');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
