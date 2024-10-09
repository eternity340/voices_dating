import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/entity/user_data_entity.dart';
import 'package:voices_dating/service/token_service.dart';
import '../../../../../../constants/Constant_styles.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/wink_entity.dart';
import '../../../net/dio.client.dart';
import '../../../net/api_constants.dart';
import '../../../constants/constant_data.dart';

class WinkSelectionBottomSheet {
  static Future<void> show({
    required String title,
    required Function(WinkEntity) onItemSelected,
  }) async {
    List<WinkEntity> winkTypes = await _fetchWinkTypes();
    if (winkTypes.isNotEmpty) {
      Get.bottomSheet(
        winkBottomSheetContent(
          title: title,
          items: winkTypes.sublist(1),
          onItemSelected: onItemSelected,
        ),
      );
    }
  }

  static Future<List<WinkEntity>> _fetchWinkTypes() async {
    try {
      List<WinkEntity> winkTypes = [];
      await DioClient.instance.requestNetwork<List<WinkEntity>>(
        method: Method.get,
        url: ApiConstants.winkTypeList,
        options: Options(headers: {'token': await TokenService.instance.getToken()}),
        onSuccess: (data) {
          if (data != null) {
            winkTypes = data;
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText, msg);
        },
      );
      return winkTypes;
    } catch (e) {
      Get.snackbar(ConstantData.errorText, 'Failed to fetch wink types');
      return [];
    }
  }
}

class winkBottomSheetContent extends StatefulWidget {
  final String title;
  final List<WinkEntity> items;
  final Function(WinkEntity) onItemSelected;

  const winkBottomSheetContent({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  winkSelectionContentState createState() => winkSelectionContentState();
}

class winkSelectionContentState extends State<winkBottomSheetContent> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [Color(0xFF20E2D7), Color(0xFFD8FAAD)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      widget.title,
                      style: ConstantStyles.selectLocationStyle.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60.h, // 调整这个值以适应标题的高度
            left: 0,
            right: 0,
            bottom: 100.h, // 为底部按钮留出空间
            child: ListView.separated(
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.h,
                color: Colors.grey[300],
              ),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    widget.items[index].descr.toString(),
                    style: ConstantStyles.saveButtonTextStyle.copyWith(
                      color: selectedIndex == index ? Color(0xFF20E2D7) : null,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 50.w,
            right: 50.w,
            child: GradientButton(
              text: 'SEND',
              onPressed: () {
                if (selectedIndex != null) {
                  widget.onItemSelected(widget.items[selectedIndex!]);
                  Get.back();
                }
              },
              isDisabled: selectedIndex == null,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
