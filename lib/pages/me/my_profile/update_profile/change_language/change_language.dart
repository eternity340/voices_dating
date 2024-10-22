import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../components/background.dart';
import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../../entity/option_entity.dart';
import '../../../components/path_box.dart';
import '../../my_profile_page.dart';
import 'change_language_controller.dart';
import '../../../../../service/global_service.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  final ChangeLanguageController controller = Get.put(ChangeLanguageController());
  final GlobalService globalService = Get.find<GlobalService>();
  List<OptionEntity> languageOptions = [];

  @override
  void initState() {
    super.initState();
    _loadLanguageOptions();
  }

  Future<void> _loadLanguageOptions() async {
    try {
      languageOptions = await globalService.getLanguageOptions();
      setState(() {});
    } catch (e) {
      print('Error loading language options: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    final UserDataEntity userData = Get.arguments['userDataEntity'] as UserDataEntity;

    void navigateToMyProfile() {
      Get.offAll(
            () => MyProfilePage(),
        arguments: {
          'tokenEntity': tokenEntity,
          'userDataEntity': userData,
        },
        transition: Transition.cupertinoDialog,
        duration: Duration(milliseconds: 500),
      );
    }

    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showActionButton: false,
        showMiddleText: true,
        middleText: ConstantData.languageTitle,
        onBackPressed: navigateToMyProfile,
        usePopScope: true,
        onPopInvoked: navigateToMyProfile,
        child: Stack(
          children: [
            Positioned(
              top: 0.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  height: ScreenUtil().screenHeight,
                  child: Stack(
                    children: [
                      for (int index = 0; index < languageOptions.length; index++)
                        PathBox(
                          top: ConstantStyles.pathBoxTopSpacing + (85.h * index),
                          text: languageOptions[index].label.toString(),
                          onPressed: () {
                            // 处理语言选择
                            controller.selectLanguage(languageOptions[index]);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
