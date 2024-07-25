import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_easyrefresh/easy_refresh.dart'; // 导入 flutter_easyrefresh 包

import '../../components/all_navigation_bar.dart';
import '../../../entity/token_entity.dart';
import '../../components/background.dart';
import '../../entity/moment_entity.dart';
import '../../entity/user_data_entity.dart';
import 'components/moments_card.dart';
import 'moments_detail/moments_detail_page.dart';

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
    // Replace with your actual tokenEntity and userData initialization logic
    tokenEntity = Get.arguments['token'] as TokenEntity;
    userData = Get.arguments['userData'] as UserDataEntity;
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
                // Add your search button onTap logic here
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
              height: 650.h, // Adjust height to fit more content
              child: EasyRefresh(
                header: ClassicalHeader(
                  refreshText: "Pull to refresh",
                  refreshReadyText: "Release to refresh",
                  refreshingText: "Refreshing...",
                  refreshedText: "Refresh completed",
                  refreshFailedText: "Refresh failed",
                ),
                onRefresh: _fetchMoments,
                child: ListView.builder(
                  itemCount: _moments.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/moments/moments_detail', arguments: {'moment': _moments[index], 'token': tokenEntity, 'userData': userData});
                      },
                      child: MomentsCard(moment: _moments[index]),
                    );
                  },
                ),
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
          'filter[likes]': 1,
          'filter[day]': 30,
          'filter[photo]': 1,
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
