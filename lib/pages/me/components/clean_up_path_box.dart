import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'dart:io';
import 'dart:math' as math;
import '../../../constants/constant_styles.dart';
import '../../../image_res/image_res.dart';

class CleanUpPathBox extends StatefulWidget {
  final double top;
  final String text;

  const CleanUpPathBox({
    Key? key,
    required this.top,
    required this.text,
  }) : super(key: key);

  @override
  _CleanUpPathBoxState createState() => _CleanUpPathBoxState();
}

class _CleanUpPathBoxState extends State<CleanUpPathBox> {
  bool _isLoading = false;
  String _cacheSize = "...";

  @override
  void initState() {
    super.initState();
    _calculateCacheSize();
  }

  Future<void> _calculateCacheSize() async {
    final cacheDir = await getTemporaryDirectory();
    final size = await _getDirSize(cacheDir);
    setState(() {
      _cacheSize = _formatSize(size);
    });
  }

  Future<int> _getDirSize(Directory dir) async {
    int size = 0;
    try {
      List<FileSystemEntity> entities = dir.listSync(recursive: true, followLinks: false);
      for (var entity in entities) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    } catch (e) {
      LogUtil.e('Error while getting directory size: $e');
      Get.snackbar(ConstantData.errorText, e.toString());
    }
    return size;
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return ((bytes / math.pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
  }

  Future<void> _clearCache() async {
    setState(() => _isLoading = true);

    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
        cacheDir.createSync();
        Get.snackbar(ConstantData.successText, 'memory clean up');
        await _calculateCacheSize(); // 重新计算缓存大小
      }
    } catch (e) {
      Get.snackbar(ConstantData.failedText,e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: (MediaQuery.of(context).size.width - 335.w) / 2,
      child: Container(
        width: 335.w,
        height: 69.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.5.h),
          child: Row(
            children: [
              Text(
                widget.text,
                style: ConstantStyles.pathBoxTextStyle,
              ),
              Spacer(),
              Text(
                _cacheSize,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 10.w),
              if (_isLoading)
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                )
              else
                IconButton(
                  onPressed: _clearCache,
                  icon: Image.asset(
                    ImageRes.pathBoxImage,
                    width: 18.w,
                    height: 20.h,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
