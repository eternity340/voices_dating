import 'package:common_utils/common_utils.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/entity/token_entity.dart';
import 'package:voices_dating/entity/user_data_entity.dart';
import 'package:get/get.dart';
import '../../service/global_service.dart';

class MeController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;
  final GlobalService globalService = Get.find<GlobalService>();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final data = await globalService.getUserData();

      if (data != null) {
        userData = data;
      } else {
        LogUtil.e(ConstantData.userDataNotFound);
      }
    } catch (e) {
      LogUtil.e(e.toString());
    }
  }
}
