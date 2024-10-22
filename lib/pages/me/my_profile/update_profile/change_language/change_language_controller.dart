import 'package:get/get.dart';

import '../../../../../entity/option_entity.dart';

class ChangeLanguageController extends GetxController {
  void selectLanguage(OptionEntity language) {
    // 处理语言选择逻辑
    print('Selected language: ${language.label}');
    // 可能需要更新用户设置或执行其他操作
  }
}
