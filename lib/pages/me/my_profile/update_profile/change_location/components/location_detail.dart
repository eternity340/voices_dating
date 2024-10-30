import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:voices_dating/net/api_constants.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../components/background.dart';
import '../../../../../../constants/Constant_styles.dart';
import '../../../../../../constants/constant_data.dart';
import '../../../../../../entity/city_entity.dart';
import '../../../../../../entity/token_entity.dart';
import '../../../../../../entity/user_data_entity.dart';
import '../../../../../../image_res/image_res.dart';
import '../../../../../../net/dio.client.dart';
import '../../../../../../service/global_service.dart';
import '../../../../../../storage/location_data_db.dart';
import 'location_selection_bottom_sheet.dart';

class LocationDetail extends StatefulWidget {
  const LocationDetail({Key? key}) : super(key: key);

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetail> {
  String selectedCountry = ConstantData.selectedCountry;
  String selectedState = ConstantData.selectedState;
  String selectedCity = ConstantData.selectedCity;
  final GlobalService globalService = Get.find<GlobalService>();
  late UserDataEntity userData;
  late TokenEntity tokenEntity;
  int? selectedStateId;
  List<CityEntity> cities = [];
  bool isButtonEnabled = false;
  bool isCityLoading = false;
  bool isStateLoading = false;
  List<String> states = [];

  @override
  void initState() {
    super.initState();
    userData = Get.arguments['userDataEntity'] as UserDataEntity;
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      showBackgroundImage: false,
      showMiddleText: true,
      middleText: ConstantData.locationHeaderTitle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 100.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                children: [
                  _buildLocationBox(
                      'Country: $selectedCountry',
                      ImageRes.pathBoxImage,
                      ConstantData.countryText
                  ),
                  SizedBox(height: 20.h),
                  _buildLocationBox(
                      'State: $selectedState',
                      ImageRes.pathBoxImage,
                      ConstantData.stateText
                  ),
                  SizedBox(height: 20.h),
                  _buildLocationBox(
                      'City: $selectedCity',
                      ImageRes.pathBoxImage,
                      ConstantData.cityText
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.h,
              right: 0.w,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(-8.w, 0, 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: isButtonEnabled
                        ? [Color(0xFFD6FAAE), Color(0xFF20E2D7)]
                        : [Color(0xFFC3C3CB), Color(0xFFC3C3CB)],
                  ),
                  borderRadius: BorderRadius.circular(24.5.r),
                ),
                width: 88.w,
                height: 36.h,
                child: TextButton(
                  onPressed: isButtonEnabled ? updateProfile : null,
                  child: Text(
                      ConstantData.saveText,
                      style: ConstantStyles.actionButtonTextStyle
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBox(String text, String iconPath, String type) {
    bool isEnabled = type == ConstantData.countryText ||
        (type == ConstantData.stateText &&
            selectedCountry != ConstantData.selectedCountry &&
            !isStateLoading &&
            states.isNotEmpty) ||
        (type == ConstantData.cityText &&
            selectedState != ConstantData.selectedState &&
            selectedState.isNotEmpty &&
            !isCityLoading &&
            cities.isNotEmpty);

    return GestureDetector(
      onTap: isEnabled ? () => _showLocationSelection(context, type) : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          width: 335.w,
          height: 69.h,
          decoration: BoxDecoration(
            color: Color(0xFFF8F8F9),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    text,
                    style: ConstantStyles.locationListStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if ((type == ConstantData.stateText && isStateLoading) ||
                    (type == ConstantData.cityText && isCityLoading))
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                    ),
                  )
                else if (isEnabled)
                  Image.asset(
                    iconPath,
                    width: 10.w,
                    height: 12.h,
                  )
                else
                  SizedBox(width: 10.w, height: 12.h), // 占位
              ],
            ),
          ),
        ),
      ),
    );
  }



  void _showLocationSelection(BuildContext context, String type) async {
    final items = await _getItemsByType(type);

    if (items.isEmpty) {
      Get.snackbar(
        'No Items Available',
        'Please select a ${type == ConstantData.stateText ? 'country' : 'state'} first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.bottomSheet(
      LocationSelectionBottomSheet(
        title: 'Select ${type.capitalize}',
        items: items,
        onItemSelected: (selectedItem) {
          setState(() {
            if (type == ConstantData.countryText) {
              selectedCountry = selectedItem;
              selectedState = ConstantData.selectedState;
              selectedCity = ConstantData.selectedCity;
              isButtonEnabled = true;
              _getStates(selectedCountry);
            } else if (type == ConstantData.stateText) {
              selectedState = selectedItem;
              selectedCity = ConstantData.selectedCity;
              _getStateId(selectedState);
            } else if (type == ConstantData.cityText) {
              selectedCity = selectedItem;
            }
          });
        },
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.transparent,
    );
  }

 /* Future<List<String>> _getItemsByType(String type) async {
    if (type == ConstantData.countryText) {
      return (await LocationDataDB.db.getCountries).map((country) => country.couName!).toList();
    } else if (type == ConstantData.stateText) {
      return states;
    } else if (type == ConstantData.cityText) {
      return cities.map((city) => city.cityName!).toList();
    }
    return [];
  }*/

  void _getStates(String countryName) async {
    setState(() {
      isStateLoading = true;
      states = [];
    });
    int countryId = await LocationDataDB.db.getCountryIdByName(countryName) ?? -1;
    if (countryId != -1) {
      states = (await LocationDataDB.db.getStatesListById(countryId)).map((state) => state.sttName!).toList();
    }
    setState(() {
      isStateLoading = false;
    });
  }

  Future<List<String>> _getItemsByType(String type) async {
    if (type == ConstantData.countryText) {
      return (await LocationDataDB.db.getCountries).map((country) => country.couName!).toList();
    } else if (type == ConstantData.stateText) {
      if (selectedCountry != ConstantData.selectedCountry) {
        int countryId = await LocationDataDB.db.getCountryIdByName(selectedCountry) ?? -1;
        if (countryId != -1) {
          return (await LocationDataDB.db.getStatesListById(countryId)).map((state) => state.sttName!).toList();
        }
      }
    } else if (type == ConstantData.cityText) {
      return cities.map((city) => city.cityName!).toList();
    }
    return [];
  }

  void _getStateId(String stateName) async {
    setState(() {
      isCityLoading = true;
      selectedCity = ConstantData.selectedCity; // 重置城市选择
    });
    selectedStateId = await LocationDataDB.db.getStateIdByName(stateName);
    if (selectedStateId != null) {
      await _fetchCities(selectedStateId!);
    } else {
      setState(() {
        isCityLoading = false;
        cities = []; // 清空城市列表
      });
    }
  }

  Future<void> _fetchCities(int stateId) async {
    await DioClient.instance.requestNetwork<List<CityEntity>>(
      method: Method.get,
      url: ApiConstants.getCityList,
      queryParameters: {'stateId': stateId},
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        setState(() {
          cities = data ?? [];
          isCityLoading = false;
          if (cities.isEmpty) {
            selectedCity = ConstantData.selectedCity; // 如果城市列表为空，重置城市选择
          }
        });
      },
      onError: (code, msg, data) {
        LogUtil.e(msg);
        setState(() {
          isCityLoading = false;
          cities = []; // 发生错误时清空城市列表
          selectedCity = ConstantData.selectedCity; // 重置城市选择
        });
      },
    );
  }


  void updateProfile() async {
    int countryId = await LocationDataDB.db.getCountryIdByName(selectedCountry) ?? 0;
    int stateId = 0;
    int cityId = 0;

    if (selectedState.isNotEmpty && selectedState != ConstantData.selectedState) {
      stateId = await LocationDataDB.db.getStateIdByName(selectedState) ?? 0;
    }

    if (selectedCity.isNotEmpty && selectedCity != ConstantData.selectedCity) {
      cityId = int.tryParse(cities.firstWhereOrNull((city) => city.cityName == selectedCity)?.cityId ?? '') ?? 0;
    }

    Map<String, dynamic> updateParams = {
      'user[countryId]': countryId,
      'user[stateId]': stateId,
      'user[cityId]': cityId,
    };

    await DioClient.instance.requestNetwork<void>(
      method: Method.post,
      url: ApiConstants.updateProfile,
      queryParameters: updateParams,
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) async {
        await globalService.refreshUserData();
        UserDataEntity? updatedUserData = globalService.userDataEntity.value;
        Get.offNamed(AppRoutes.meMyProfile, arguments: {
          'userDataEntity': updatedUserData,
          'tokenEntity': tokenEntity,
        });
      },
      onError: (code, msg, data) {
        Get.snackbar(ConstantData.failedText, msg);
      },
    );
  }

}

