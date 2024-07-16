import 'package:dio/dio.dart' as dio;
import 'package:first_app/entity/token_entity.dart';
import 'package:first_app/entity/user_data_entity.dart';
import 'package:get/get.dart';

class MeController extends GetxController {
  late TokenEntity tokenEntity;
  late UserDataEntity userData;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final dio.Dio dioInstance = dio.Dio();
    try {
      final response = await dioInstance.get(
        'https://api.masonvips.com/v1/get_profile',
        options: dio.Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        userData = UserDataEntity.fromJson(data['data']);
        update();
      } else {
        print('Failed to obtain user data');
      }
    } catch (e) {
      print('request error: $e');
    }
  }
}
