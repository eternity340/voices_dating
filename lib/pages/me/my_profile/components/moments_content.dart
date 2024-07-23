import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'moment_card.dart';
import '../../../../entity/moment_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';

class MomentsContent extends StatefulWidget {
  final TokenEntity tokenEntity;
  final UserDataEntity userData;

  MomentsContent({required this.tokenEntity, required this.userData});

  @override
  _MomentsContentState createState() => _MomentsContentState();
}

class _MomentsContentState extends State<MomentsContent> {
  List<MomentEntity> _moments = [];

  @override
  void initState() {
    super.initState();
    _fetchMoments();
  }

  Future<void> _fetchMoments() async {
    try {
      Dio dio = Dio();
      Response response = await dio.get(
        'https://api.masonvips.com/v1/timelines',
        queryParameters: {
          'profId': widget.userData.userId,
        },
        options: Options(
          headers: {
            'token': widget.tokenEntity.accessToken,
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

  void _removeMoment(MomentEntity moment) {
    setState(() {
      _moments.remove(moment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 36.w),
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
    );
  }
}
