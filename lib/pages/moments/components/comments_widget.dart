import 'package:first_app/entity/comment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/token_entity.dart';

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

  @override
  void initState() {
    super.initState();
    isLikedList = List.filled(widget.moment.comments?.length ?? 0, false);
    likeCountList = List.filled(widget.moment.comments?.length ?? 0, '0');
    _fetchLikeCounts();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
      child: CupertinoActivityIndicator(radius: 15.0),
    )
        : Column(
      children: [
        ..._buildCommentWidgets(widget.moment.comments),
      ],
    );
  }

  List<Widget> _buildCommentWidgets(List<CommentEntity>? comments) {
    List<Widget> commentWidgets = [];

    if (comments != null) {
      for (var i = 0; i < comments.length; i++) {
        var comment = comments[i];
        commentWidgets.add(
          SizedBox(
            height: 105.h, // 每个评论的高度
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
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      height: 24 / 14,
                      letterSpacing: -0.01,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
                Positioned(
                  left: 59.w,
                  top: 40.h,
                  child: Text(
                    _formatTimestamp(comment.commentCreated),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      height: 24 / 14,
                      letterSpacing: -0.01,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.w,
                  top: 65.h,
                  child: Text(
                    comment.commentContent?.toString() ?? '',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      height: 24 / 14,
                      letterSpacing: -0.01,
                      color: Color(0xFF000000),
                    ),
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
                      isLikedList[i]
                          ? 'assets/images/button_like_active.png'
                          : 'assets/images/button_like_inactive.png',
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
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.0071428571827709675,
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
    }
    return commentWidgets;
  }

  Future<void> _fetchLikeCounts() async {
    if (widget.moment.comments == null) return;
    Dio dio = Dio();
    String? token = widget.tokenEntity.accessToken;
    try {
      var response = await dio.get(
        'https://api.masonvips.com/v1/get/timeline/comments',
        queryParameters: {'timelineId': widget.moment.timelineId},
        options: Options(headers: {'token': token}),
      );
      if (response.data['code'] == 200) {
        List<dynamic> data = response.data['data'];
        likeCountList = []; // 初始化 likeCountList
        isLikedList = []; // 初始化 isLikedList
        // 迭代 data 列表并将 commentLikes 添加到 likeCountList，同时设置 isLikedList 的值
        for (var item in data) {
          likeCountList.add(item['commentLikes'].toString());
          isLikedList.add(item['commentLiked'] == '1');
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to fetch like count for comment: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _toggleLikeStatus(int index, String? commentId) async {
    if (commentId == null) return;
    Dio dio = Dio();
    String? token = widget.tokenEntity.accessToken;
    bool isLiked = !isLikedList[index];

    try {
      var response = await dio.post(
        'https://api.masonvips.com/v1/like/timeline/comment',
        queryParameters: {'commentId': int.tryParse(commentId)},
        options: Options(headers: {'token': token}),
      );
      if (response.data['code'] == 200) {
        setState(() {
          isLikedList[index] = isLiked;
          _updateLikeCount(index, isLiked);
        });
      }
    } catch (e) {
      print('Failed to toggle like status for comment: $e');
    }
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
