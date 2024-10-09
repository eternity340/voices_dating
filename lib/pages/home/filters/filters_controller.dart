import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/routes/app_routes.dart';
import '../../../entity/current_location_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../net/dio.client.dart';
import '../../../storage/location_data_db.dart';
import '../../../entity/city_entity.dart';
import '../../../constants/constant_data.dart';
import '../../../net/api_constants.dart';

class FiltersController extends GetxController {
  final TokenEntity tokenEntity = Get.arguments?['tokenEntity'] as TokenEntity;
  final DioClient dioClient = DioClient.instance;
  final RxBool isButtonEnabled = true.obs;
  var minAge = '19'.obs;
  var maxAge = '99'.obs;

  var selectedLookingFor = <String>[].obs;

  var locationOption = 'anywhere'.obs;
  var selectedCountry = ConstantData.selectedCountry.obs;
  var selectedState = ConstantData.selectedState.obs;
  var selectedCity = ConstantData.selectedCity.obs;
  var isCityLoading = false.obs;
  String? selectedCountryId;
  String? selectedStateId;
  String? selectedCityId;
  RxList<CityEntity> cities = <CityEntity>[].obs;

  var currentLocationAddress = ''.obs;
  var selectedDistance = RxnString();

  @override
  void onInit() {
    super.onInit();
    selectedLookingFor.value = ["1", "2"]; // Default: men and women
  }

  void updateSelectedLookingFor(List<String> selected) {
    if (selected.isNotEmpty) {
      selectedLookingFor.value = selected;
    }
  }

  void toggleLookingFor(String option) {
    if (selectedLookingFor.contains(option)) {
      selectedLookingFor.remove(option);
    } else {
      selectedLookingFor.add(option);
    }
  }

  bool isSelected(String option) {
    return selectedLookingFor.contains(option);
  }

  String getLookingForText() {
    List<String> texts = [];
    if (selectedLookingFor.contains("1")) texts.add('Men');
    if (selectedLookingFor.contains("2")) texts.add('Women');
    if (selectedLookingFor.contains("3")) texts.add('Couple');
    return texts.isEmpty ? 'Select options' : texts.join(', ');
  }

  void setLocationOption(String value) {
    locationOption.value = value;
    switch (value) {
      case 'currentLocation':
        fetchCurrentLocation();
        selectedCountry.value = ConstantData.selectedCountry;
        selectedState.value = ConstantData.selectedState;
        selectedCity.value = ConstantData.selectedCity;
        break;
      case 'liveIn':
        currentLocationAddress.value = '';
        break;
      case 'anywhere':
        currentLocationAddress.value = '';
        selectedCountry.value = ConstantData.selectedCountry;
        selectedState.value = ConstantData.selectedState;
        selectedCity.value = ConstantData.selectedCity;
        break;
    }
    update(); // 确保 UI 更新
  }


  Future<List<String>> getItemsByType(String type) async {
    print("Getting items for type: $type");
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

  void updateLiveInLocation(String type, String selectedItem) async {
    if (type == ConstantData.countryText) {
      selectedCountry.value = selectedItem;
      selectedState.value = ConstantData.selectedState;
      selectedCity.value = ConstantData.selectedCity;
      selectedCountryId = (await LocationDataDB.db.getCountryIdByName(selectedItem))?.toString();
      selectedStateId = null;
      selectedCityId = null;
      isButtonEnabled.value = true;
    } else if (type == ConstantData.stateText) {
      selectedState.value = selectedItem;
      selectedCity.value = ConstantData.selectedCity;
      selectedCityId = null;
      if (selectedItem == 'All states') {
        selectedStateId = null;
        cities.clear();
        isCityLoading.value = false;
      } else {
        selectedStateId = (await LocationDataDB.db.getStateIdByName(selectedItem))?.toString();
        await _fetchCities(selectedStateId!);
      }
    } else if (type == ConstantData.cityText) {
      selectedCity.value = selectedItem;
      selectedCityId = cities.firstWhereOrNull((city) => city.cityName == selectedItem)?.cityId?.toString();
    }
    update(); // 添加这行来确保 UI 更新
  }


  Future<void> _fetchCities(String stateId) async {
    isCityLoading.value = true;
    await DioClient.instance.requestNetwork<List<CityEntity>>(
      method: Method.get,
      url: ApiConstants.getCityList,
      queryParameters: {'stateId': stateId},
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null) {
          cities.value = data;
        } else {
          cities.clear();
        }
        isCityLoading.value = false;
      },
      onError: (code, msg, data) {
        print("Error fetching cities: $msg");
        cities.clear();
        isCityLoading.value = false;
      },
    );
  }

  Future<void> fetchCurrentLocation() async {
    await DioClient.instance.requestNetwork<CurrentLocationEntity>(
      method: Method.get,
      url: ApiConstants.currentLocation,
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null) {
          currentLocationAddress.value = data.toAddress();
        }
      },
      onError: (code, msg, data) {
        LogUtil.e(msg);
        currentLocationAddress.value = 'Failed to fetch location';
      },
    );
  }

  void onSavePressed() {
    String lookingForValue;
    if (selectedLookingFor.length == 1) {
      lookingForValue = selectedLookingFor[0];
    } else if (selectedLookingFor.length > 1) {
      lookingForValue = '3';
    } else {
      lookingForValue = '';
    }

    Map<String, dynamic> filterParams = {
      'minAge': minAge.value,
      'maxAge': maxAge.value,
      'lookingFor': lookingForValue,
      'countryId': selectedCountryId,
      'stateId': selectedStateId,
      'cityId': selectedCityId,
      'selectedDistance': selectedDistance.value
    };

    Get.toNamed(AppRoutes.homeFiltersSearch, arguments: {
      'tokenEntity': tokenEntity,
      'filterParams': filterParams
    });
  }

}
