import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../entity/moment_entity.dart';
import '../../../entity/token_entity.dart';
import 'love_button.dart';

class MomentsCard extends StatefulWidget {
  final MomentEntity moment;
  final bool showButtons;
  final TokenEntity tokenEntity;
  final VoidCallback onLoveButtonPressed;

  const MomentsCard({
    Key? key,
    required this.moment,
    required this.tokenEntity,
    this.showButtons = true,
    required this.onLoveButtonPressed,
  }) : super(key: key);

  @override
  _MomentsCardState createState() => _MomentsCardState();
}

class _MomentsCardState extends State<MomentsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      width: 335.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000).withOpacity(0.0642),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(widget.moment.avatar ?? 'assets/images/placeholder1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        widget.moment.username ?? 'Unknown',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14.sp,
                          height: 24 / 14,
                          color: Color(0xFF000000),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  widget.moment.timelineDescr ?? 'No description available',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    height: 24 / 16,
                    letterSpacing: -0.01,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 16.h),
                if (widget.moment.attachments != null && widget.moment.attachments!.length == 1)
                  Container(
                    width: 303.w,
                    height: 400.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(
                        image: NetworkImage(widget.moment.attachments!.first.url ?? 'assets/images/placeholder1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.moment.attachments?.map((attachment) {
                        return Container(
                          width: 137.09.w,
                          height: 174.h,
                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            image: DecorationImage(
                              image: NetworkImage(attachment.url ?? 'assets/images/placeholder1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList() ?? [],
                    ),
                  ),
              ],
            ),
          ),
          if (widget.showButtons)
            Positioned(
              right: 16.w,
              top: 12.h,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // 第一个按钮的点击事件处理
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        color: Color(0xFFF8F8F9),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/icon_chat_inactive.png',
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  LoveButton(
                    moment: widget.moment,
                    tokenEntity: widget.tokenEntity,
                    onLoveButtonPressed: widget.onLoveButtonPressed, // 传递回调函数
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
