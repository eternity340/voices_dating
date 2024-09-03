import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../components/background.dart';
import '../../../../../../components/bar/bar_scale_pulse_out_loading.dart';
import '../../../../../../constants/Constant_styles.dart';
import '../../../../../../constants/constant_data.dart';
import '../components/record_button.dart';
import 'record_controller.dart';

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RecordController controller = Get.put(RecordController(
      Get.arguments['token'],
      Get.arguments['userData'],
    ));

    return Scaffold(
      body: Background(
        showMiddleText: true,
        showBackgroundImage: false,
        middleText: ConstantData.introductionText,
        child: GetBuilder<RecordController>(
          builder: (_) {
            return Stack(
              children: [
                Positioned(
                  top: 0.h,
                  right: 0.w,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(-8.w, 0, 0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF20E2D7), Color(0xFFD6FAAE)],
                      ),
                      borderRadius: BorderRadius.circular(24.5.r),
                    ),
                    width: 88.w,
                    height: 36.h,
                    child: TextButton(
                      onPressed: controller.saveRecording,
                      child: Text(
                        ConstantData.saveText,
                        style: ConstantStyles.actionButtonTextStyle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 152.w,
                  top: 517.h,
                  child: Text(
                    controller.timerText,
                    style: ConstantStyles.timeTextStyle,
                  ),
                ),
                Positioned(
                  left: 165.w,
                  top: 671.h,
                  child: Text(
                    controller.isRecording ? ConstantData.endText : ConstantData.starText,
                    style: ConstantStyles.starOrEndTextStyle,
                  ),
                ),
                Positioned(
                  left: 132.5.w,
                  top: 565.h,
                  child: RecordButton(
                    onLongPressStart: controller.startRecording,
                    onLongPressEnd: controller.stopRecording,
                  ),
                ),
                if (controller.isRecording)
                  Positioned(
                    left: 113.w,
                    top: 392.h,
                    child: SizedBox(
                      width: 120.w,
                      height: 120.h,
                      child: BarScalePulseOutLoading(
                        barCount: 20,
                        color: Color(0xFF2FE4D4),
                        width: 2.w,
                        height: 15.h,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
