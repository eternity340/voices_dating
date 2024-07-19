import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../entity/block_member_entity.dart';
import '../../../../entity/token_entity.dart';

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
      final response = await dio.get(
        'https://api.masonvips.com/v1/blocked_users',
        options: Options(
          headers: {
            'token': tokenEntity.accessToken!,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        blockedMembers.value = data.map((json) => BlockMemberEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load blocked members');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load blocked members: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      final response = await dio.post(
        'https://api.masonvips.com/v1/unblock_user',
        options: Options(
          headers: {
            'token': tokenEntity.accessToken!,
          },
        ),
        queryParameters: {
          'userId': userId,
        },
      );

      final responseData = response.data;
      if (responseData['code'] == 200 && responseData['data']['ret'] == true) {
        Get.snackbar('Success', 'Unlock user success');
        fetchBlockedMembers();
      } else {
        Get.snackbar('Error', 'Failed to unlock user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
    }
  }
}
