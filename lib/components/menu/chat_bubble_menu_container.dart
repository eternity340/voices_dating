import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_bubble_menu_shape.dart';

// 长按气泡菜单的容器
class ChatBubbleMenuContainer extends StatefulWidget {
  const ChatBubbleMenuContainer({
    Key? key,
    required this.bubbleOffset,
    required this.bubbleSize,
    required this.onBubbleMenuButtonPressed,
  }) : super(key: key);

  final Offset bubbleOffset;
  final Size bubbleSize;
  final Function(int index) onBubbleMenuButtonPressed;

  @override
  State<ChatBubbleMenuContainer> createState() =>
      _ChatBubbleMenuContainerState();
}

class _ChatBubbleMenuContainerState extends State<ChatBubbleMenuContainer> {
  @override
  Widget build(BuildContext context) {
    double itemWidth = 60;
    double itemHeight = 40;

    double menuWidth = itemWidth;
    double menuHeight = itemHeight;

    double dx =
        widget.bubbleOffset.dx + (widget.bubbleSize.width - menuWidth) / 2.0;
    double dy = widget.bubbleOffset.dy;

    double arrowSize = 10.0;

    return Stack(
      children: [
        Positioned(
          left: dx,
          top: dy - menuHeight - arrowSize * 1.8,
          child: buildMenu(
            context,
            Size(itemWidth, itemHeight),
          ),
        ),
        Positioned(
          left: dx + menuWidth / 2.0 + arrowSize / 2.0,
          top: dy - arrowSize,
          child: CustomPaint(
            painter: ChatBubbleMenuShape(
                const Color.fromARGB(255, 0x45, 0x45, 0x45), arrowSize),
          ),
        ),
      ],
    );
  }

  Widget buildMenu(BuildContext context, Size itemSize) {
    return GestureDetector(
      onTap: () {
        widget.onBubbleMenuButtonPressed(1);
      },
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0x45, 0x45, 0x45),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(3.sp),
            topLeft: Radius.circular(3.sp),
            bottomLeft: Radius.circular(3.sp),
            bottomRight: Radius.circular(3.sp),
          ),
        ),
        child: Wrap(
          spacing: 8.0, // 主轴(水平)方向间距
          runSpacing: 4.0, // 纵轴（垂直）方向间距
          alignment: WrapAlignment.center, //沿主轴方向居中
          children: [
            ChatBubbleMenuButton(
              width: itemSize.width,
              height: itemSize.height,
              name: "UNSEND",
            ),
          ],
        ),
      ),
    );
  }
}

// 显示气泡菜单
class ChatBubbleMenuButton extends StatelessWidget {
  const ChatBubbleMenuButton({
    Key? key,
    required this.name,
    required this.width,
    required this.height,
  }) : super(key: key);

  final String name;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 2.0,
          ),
          Text(
            name,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
