import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/components/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/pages/home/filters/filters_controller.dart';

import '../../../../utils/common_utils.dart';
import '../../components/feel_detail_card.dart';
import 'filters_search_controller.dart';


class FiltersSearchPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    final FiltersSearchController controller = Get.put(FiltersSearchController());

    return Scaffold(
      body:Stack(
        children: [
          Background(
              showBackButton: true,
              showBackgroundImage: true,
              showMiddleText: true,
              middleText: ConstantData.searchText,
              child: Container()
          ),
          Obx(() {
            return controller.isLoading.value
                ? CommonUtils.loadingIndicator()
                : Positioned(
              top: 100.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: EasyRefresh(
                onRefresh: controller.onRefresh,
                onLoad: controller.onLoad,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.userList.length,
                  itemBuilder: (context, index) {
                    final user = controller.userList[index];
                    return FeelDetailCard(
                      userEntity: user,
                      tokenEntity: controller.tokenEntity,
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

}