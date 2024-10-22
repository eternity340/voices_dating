import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/common_utils.dart'; // 确保导入 CommonUtils

class ImageViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewerPage({
    Key? key,
    required this.imageUrls,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late int currentIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.imageUrls[index]),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
              );
            },
            loadingBuilder: (context, event) => Center(
              child: CommonUtils.loadingIndicator(
                color: Colors.white,
                radius: 20.0,
              ),
            ),
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(color: Colors.black),
            pageController: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          Positioned(
            top: 40.h,
            left: 10.w,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.sp),
              onPressed: () => Get.back(),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 20.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${currentIndex + 1} / ${widget.imageUrls.length}',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
