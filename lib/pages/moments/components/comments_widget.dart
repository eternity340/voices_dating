import 'package:common_utils/common_utils.dart';
import 'package:voices_dating/entity/comment_entity.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../constants/Constant_styles.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../image_res/image_res.dart';
import '../../../net/dio.client.dart';

class CommentWidget extends StatefulWidget {
  final MomentEntity moment;
  final TokenEntity tokenEntity;

  CommentWidget({Key? key, required this.moment, required this.tokenEntity}) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late List<bool> isLikedList;
  late List<String> likeCountList;
  bool isLoading = true;
  List<CommentEntity> comments = [];
  final DioClient dioClient = DioClient.instance;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
      child: CupertinoActivityIndicator(radius: 15.0),
    )
        : Column(
      children: [
        ..._buildCommentWidgets(comments),
      ],
    );
  }

  List<Widget> _buildCommentWidgets(List<CommentEntity> comments) {
    List<Widget> commentWidgets = [];

    for (var i = 0; i < comments.length; i++) {
      var comment = comments[i];
      commentWidgets.add(
        SizedBox(
          height: 105.h,
          child: Stack(
            children: [
              Positioned(
                left: 0.w,
                top: 20.h,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    image: DecorationImage(
                      image: NetworkImage(comment.avatar?.toString() ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 59.w,
                top: 15.h,
                child: Text(
                  comment.username?.toString() ?? '',
                  style: ConstantStyles.usernameStyle,
                ),
              ),
              Positioned(
                left: 59.w,
                top: 40.h,
                child: Text(
                  _formatTimestamp(comment.commentCreated),
                  style: ConstantStyles.timestampStyle,
                ),
              ),
              Positioned(
                left: 0.w,
                top: 65.h,
                child: Text(
                  comment.commentContent?.toString() ?? '',
                  style: ConstantStyles.commentContentStyle,
                ),
              ),
              Positioned(
                left: 270.w,
                top: 15.h,
                child: GestureDetector(
                  onTap: () {
                    _toggleLikeStatus(i, comment.commentId);
                  },
                  child: Image.asset(
                    isLikedList[i] ? ImageRes.buttonLikeActive : ImageRes.buttonLikeInactive,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ),
              Positioned(
                left: 255.w,
                top: 18.h,
                child: Text(
                  likeCountList[i],
                  style: ConstantStyles.likeCountStyle.copyWith(
                    color: isLikedList[i] ? Color(0xFF2EE4D3) : Color(0xFF000000),
                  ),
                ),
              ),
              Positioned(
                left: 0.w,
                top: 104.h,
                right: 16.w,
                child: Divider(
                  height: 1,
                  color: Color(0xFFEBEBEB),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return commentWidgets;
  }

  Future<void> _fetchComments() async {
    await dioClient.requestNetwork<List<dynamic>>(
      method: Method.get,
      url: ApiConstants.getTimelineComments,
      queryParameters: {'timelineId': widget.moment.timelineId},
      options: Options(headers: {'token': widget.tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null) {
          comments = data.map((item) => CommentEntity.fromJson(item as Map<String, dynamic>)).toList();
          likeCountList = comments.map((comment) => comment.commentLikes.toString()).toList();
          isLikedList = comments.map((comment) => comment.commentLiked == 1).toList();
          setState(() {
            isLoading = false;
          });
        }
      },
      onError: (code, msg, data) {
        LogUtil.e(msg);
        setState(() {
          isLoading = false;
        });
      },
    );
  }



  Future<void> _toggleLikeStatus(int index, String? commentId) async {
    if (commentId == null) return;
    bool isLiked = !isLikedList[index];

    await dioClient.requestNetwork<dynamic>(
      method: Method.post,
      url: ApiConstants.likeTimelineComment,
      queryParameters: {'commentId': int.tryParse(commentId)},
      options: Options(headers: {'token': widget.tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data['code'] == 200) {
          setState(() {
            isLikedList[index] = isLiked;
            _updateLikeCount(index, isLiked);
          });
        }
      },
      onError: (code, msg, data) {
        print('Failed to toggle like status for comment: $msg');
      },
    );
  }


  void _updateLikeCount(int index, bool isLiked) {
    if (isLiked) {
      // Increment like count
      int currentCount = int.parse(likeCountList[index]);
      likeCountList[index] = (currentCount + 1).toString();
    } else {
      // Decrement like count
      int currentCount = int.parse(likeCountList[index]);
      if (currentCount > 0) {
        likeCountList[index] = (currentCount - 1).toString();
      }
    }
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}