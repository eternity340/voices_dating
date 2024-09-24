import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../components/audio_player_widget.dart';
import '../../../../../../image_res/image_res.dart';
import 'audio_duration_display.dart';

class AudioItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String audioPath;

  const AudioItem({
    Key? key,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    required this.audioPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 335.w,
        height: 69.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected
              ? Border.all(color: Color(0xFFABFFCF), width: 2.w)
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              left: isSelected ? 14.w : 16.w,
              top: isSelected ? 15.5.h : 17.5.h,
              child: Row(
                children: [
                  AudioPlayerWidget(
                    audioPath: audioPath,
                  ),
                  SizedBox(width: 10.w),
                  AudioDurationDisplay(audioPath: audioPath),
                ],
              ),
            ),
            Positioned(
              left: isSelected ? 246.w : 248.w,
              top: isSelected ? 18.5.h : 20.5.h,
              child: Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFAAFCCF) : Color(0xFFE1E1E1),
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 20.w)
                    : null,
              ),
            ),
            Positioned(
              left: isSelected ? 291.w : 293.w,
              top: isSelected ? 20.5.h : 22.5.h,
              child: GestureDetector(
                onTap: onDelete,
                child: Image.asset(
                  ImageRes.iconDeleteImagePath,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
