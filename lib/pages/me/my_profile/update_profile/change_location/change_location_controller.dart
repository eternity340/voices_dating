import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:voices_dating/entity/city_entity.dart';
import 'package:voices_dating/entity/token_entity.dart';
import 'package:voices_dating/entity/user_data_entity.dart';
import 'package:voices_dating/net/dio.client.dart';
import 'package:voices_dating/service/global_service.dart';
import 'package:voices_dating/storage/location_data_db.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:common_utils/common_utils.dart';

import '../../my_profile_page.dart';

class ChangeLocationController extends GetxController {
  final GlobalService globalService = Get.find<GlobalService>();

  final selectedCountry = ConstantData.selectedCountry.obs;
  final selectedState = ConstantData.selectedState.obs;
  final selectedCity = ConstantData.selectedCity.obs;

  late UserDataEntity userData;
  late TokenEntity tokenEntity;

  final selectedStateId = RxnInt();
  final cities = <CityEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    userData = Get.arguments['userDataEntity'] as UserDataEntity;
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  }

  Future<List<String>> getItemsByType(String type) async {
    if (type == ConstantData.countryText) {
      return (await LocationDataDB.db.getCountries).map((country) => country.couName!).toList();
    } else if (type == ConstantData.stateText) {
      if (selectedCountry.value != ConstantData.selectedCountry) {
        int countryId = await LocationDataDB.db.getCountryIdByName(selectedCountry.value) ?? -1;
        if (countryId != -1) {
          return (await LocationDataDB.db.getStatesListById(countryId)).map((state) => state.sttName!).toList();
        }
      }
    } else if (type == ConstantData.cityText) {
      return cities.map((city) => city.cityName!).toList();
    }
    return [];
  }

  void getStateId(String stateName) async {
    selectedStateId.value = await LocationDataDB.db.getStateIdByName(stateName);
    if (selectedStateId.value != null) {
      fetchCities(selectedStateId.value!);
    }
  }

  void fetchCities(int stateId) {
    DioClient.instance.requestNetwork<List<CityEntity>>(
      method: Method.get,
      url: ApiConstants.getCityList,
      queryParameters: {'stateId': stateId},
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null) {
          cities.value = data;
        }
      },
      onError: (code, msg, data) {
        LogUtil.e(msg);
      },
    );
  }

  void updateProfile() async {
    int? countryId = await LocationDataDB.db.getCountryIdByName(selectedCountry.value);
    int? stateId = await LocationDataDB.db.getStateIdByName(selectedState.value);
    String? cityId = cities.firstWhereOrNull((city) => city.cityName == selectedCity.value)?.cityId?.toString();

    if (countryId == null || stateId == null || cityId == null || cityId.isEmpty) {
      Get.snackbar(ConstantData.errorText, ConstantData.invalidLocation);
      return;
    }

    await DioClient.instance.requestNetwork<void>(
      method: Method.post,
      url: ApiConstants.updateProfile,
      queryParameters: {
        'user[countryId]': countryId,
        'user[stateId]': stateId,
        'user[cityId]': cityId,
      },
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) async {
        await globalService.refreshUserData(tokenEntity.accessToken.toString());
        Get.offNamed(AppRoutes.meMyProfileChangeLocation, arguments: {
          'userDataEntity': globalService.userDataEntity.value,
          'tokenEntity': tokenEntity,
        });
      },
      onError: (code, msg, data) {
        Get.snackbar(ConstantData.failedText, msg);
      },
    );
  }

  void updateSelectedLocation(String type, String value) {
    switch (type) {
      case ConstantData.countryText:
        selectedCountry.value = value;
        selectedState.value = ConstantData.selectedState;
        selectedCity.value = ConstantData.selectedCity;
        break;
      case ConstantData.stateText:
        selectedState.value = value;
        selectedCity.value = ConstantData.selectedCity;
        getStateId(value);
        break;
      case ConstantData.cityText:
        selectedCity.value = value;
        break;
    }
  }

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

}
