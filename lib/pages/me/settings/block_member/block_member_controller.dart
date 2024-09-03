import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/net/api_constants.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../entity/block_member_entity.dart';
import '../../../../entity/ret_entity.dart';
import '../../../../entity/token_entity.dart';
import '../../../../net/dio.client.dart';

class BlockMemberController extends GetxController {
  late TokenEntity tokenEntity;
  var blockedMembers = <BlockMemberEntity>[].obs;
  var isLoading = true.obs;
  final dio = Dio();

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['token'] as TokenEntity;
    fetchBlockedMembers();
  }

  Future<void> fetchBlockedMembers() async {
    isLoading.value = true;
    try {
      await DioClient.instance.requestNetwork<List<BlockMemberEntity>>(
        method: Method.get,
        url: ApiConstants.blockedUsers,
        options: Options(
          headers: {
            'token': tokenEntity.accessToken!,
          },
        ),
        onSuccess: (data) {
          if (data != null) {
            blockedMembers.value = data;
          } else {
            blockedMembers.value = [];
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText, msg);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText,e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      await DioClient.instance.requestNetwork<RetEntity>(
        method: Method.post,
        url: ApiConstants.unblockUser,
        queryParameters: {
          'userId': userId,
        },
        options: Options(
          headers: {
            'token': tokenEntity.accessToken!,
          },
        ),
        onSuccess: (data) {
          if (data != null && data.ret == true) {
            Get.snackbar(ConstantData.successText, ConstantData.unlockSuccess);
            fetchBlockedMembers();
          } else {
            Get.snackbar(ConstantData.errorText, ConstantData.unlockFailed);
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText,msg);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText, e.toString());
    }
  }
}
