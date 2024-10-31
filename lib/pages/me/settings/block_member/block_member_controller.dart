import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/net/api_constants.dart';
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
  final DioClient dioClient = DioClient.instance;
  var page = 1.obs;
  final int offset = 20;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    fetchBlockedMembers(isRefresh: true);
  }

  Future<void> fetchBlockedMembers({bool isRefresh = false}) async {
    if (isRefresh) {
      page.value = 1;
      hasMore.value = true;
    }

    if (!hasMore.value) return;

    isLoading.value = true;
    try {
      await dioClient.requestNetwork<List<BlockMemberEntity>>(
        method: Method.get,
        url: ApiConstants.blockedUsers,
        queryParameters: {
          'page': page.value,
          'offset': offset,
        },
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
        onSuccess: (data) {
          if (data != null) {
            if (isRefresh) {
              blockedMembers.value = data;
            } else {
              blockedMembers.addAll(data);
            }
            hasMore.value = data.length >= offset;
            page.value++;
          } else {
            if (isRefresh) {
              blockedMembers.value = [];
            }
            hasMore.value = false;
          }
        },
        onError: (code, msg, data) {
          Get.snackbar(ConstantData.errorText, msg);
        },
      );
    } catch (e) {
      Get.snackbar(ConstantData.errorText, e.toString());
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

  Future<void> onLoading() async {
    await fetchBlockedMembers();
  }

  Future<void> onRefresh() async {
    await fetchBlockedMembers(isRefresh: true);
  }
}
