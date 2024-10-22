import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../../net/dio.client.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/common_utils.dart';
import 'moment_card.dart';
import '../../../../entity/moment_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../../../components/empty_state_widget.dart';
import '../../../../image_res/image_res.dart';

class MomentsContent extends StatefulWidget {
  final TokenEntity tokenEntity;
  final UserDataEntity userData;

  MomentsContent({required this.tokenEntity, required this.userData});

  @override
  _MomentsContentState createState() => _MomentsContentState();
}

class _MomentsContentState extends State<MomentsContent> {
  List<MomentEntity> _moments = [];
  bool _isInitialLoading = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  int _page = 1;
  final int _pageOffset = 5;
  late EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    _fetchMoments();
  }

  Future<void> _fetchMoments({bool isRefresh = false}) async {
    if (isRefresh) {
      _page = 1;
      _moments.clear();
      setState(() {
        _isRefreshing = true;
      });
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await DioClient.instance.requestNetwork<List<dynamic>>(
        method: Method.get,
        url: ApiConstants.timelines,
        queryParameters: {
          'page': _page,
          'offset': _pageOffset,
          'profId': widget.userData.userId
        },
        options: Options(headers: {'token': widget.tokenEntity.accessToken}),
        onSuccess: (data) {
          if (data != null) {
            List<MomentEntity> fetchedMoments = data
                .map((json) => MomentEntity.fromJson(json as Map<String, dynamic>))
                .toList();
            setState(() {
              _moments.addAll(fetchedMoments);
              _page++;
            });
            if (fetchedMoments.length < _pageOffset) {
              _easyRefreshController.finishLoad(noMore: true);
            }
          } else {
            _easyRefreshController.finishLoad(noMore: true);
          }
        },
        onError: (code, msg, data) {
          LogUtil.e(msg);
          _easyRefreshController.finishLoad(noMore: true);
        },
      );
    } catch (e) {
      LogUtil.e(e.toString());
      _easyRefreshController.finishLoad(noMore: true);
    } finally {
      setState(() {
        _isLoading = false;
        _isInitialLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _refreshMoments() async {
    await _fetchMoments(isRefresh: true);
    _easyRefreshController.finishRefresh();
  }

  void _removeMoment(MomentEntity moment) {
    setState(() {
      _moments.remove(moment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isInitialLoading)
          Center(child: CommonUtils.loadingIndicator())
        else
          EasyRefresh(
            controller: _easyRefreshController,
            onRefresh: _refreshMoments,
            onLoad: _fetchMoments,
            child: _moments.isEmpty && !_isRefreshing
                ? EmptyStateWidget(
              imagePath: ImageRes.emptyMomentsDemo1Svg,
              message: ConstantData.noMomentsText,
              imageWidth: 200.w,
              imageHeight: 200.h,
              topPadding: 100.h,
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              itemCount: _moments.length,
              itemBuilder: (context, index) {
                MomentEntity moment = _moments[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: MomentCard(
                    moment: moment,
                    tokenEntity: widget.tokenEntity,
                    onDelete: () => _removeMoment(moment),
                  ),
                );
              },
            ),
          ),
        Positioned(
          right: 16.w,
          bottom: 30.h,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              shape: CircleBorder(),
              elevation: 0,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: () {
                  Get.toNamed(AppRoutes.momentsAddMoment, arguments: {
                    'tokenEntity': widget.tokenEntity,
                    'userDataEntity': widget.userData,
                    'isMomentsPage': false
                  });
                },
                child: Container(
                  width: 55.w,
                  height: 55.w,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 36.w,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }
}
