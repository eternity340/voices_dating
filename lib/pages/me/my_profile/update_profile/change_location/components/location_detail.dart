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

  @override
  void initState() {
    super.initState();
    userData = Get.arguments['userDataEntity'] as UserDataEntity;
    tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
              showBackgroundImage: false,
              showMiddleText: true,
              middleText: ConstantData.locationHeaderTitle,
              child: Container(),
          ),
          Positioned(
            top: 150.h,
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
            top: 58.h,
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
    );
  }

  Widget _buildLocationBox(String text, String iconPath, String type) {
    bool isEnabled = type == ConstantData.countryText ||
        (type == ConstantData.stateText && selectedCountry != ConstantData.selectedCountry) ||
        (type == ConstantData.cityText && selectedState != ConstantData.selectedState && !isCityLoading);

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
                if (type == ConstantData.cityText && isCityLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                    ),
                  )
                else
                  Image.asset(
                    iconPath,
                    width: 10.w,
                    height: 12.h,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showLocationSelection(BuildContext context, String type) async {
    final items = await _getItemsByType(type);

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
    });
    selectedStateId = await LocationDataDB.db.getStateIdByName(stateName);
    if (selectedStateId != null) {
      await _fetchCities(selectedStateId!);
    }
    setState(() {
      isCityLoading = false;
    });
  }


  Future<void> _fetchCities(int stateId) async {
    await DioClient.instance.requestNetwork<List<CityEntity>>(
      method: Method.get,
      url: ApiConstants.getCityList,
      queryParameters: {'stateId': stateId},
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) {
        if (data != null) {
          setState(() {
            cities = data;
            isCityLoading = false;
          });
        }
      },
      onError: (code, msg, data) {
        LogUtil.e(msg);
        setState(() {
          isCityLoading = false;
        });
      },
    );
  }


  void updateProfile() async {
    int? countryId = await LocationDataDB.db.getCountryIdByName(selectedCountry);
    int? stateId = await LocationDataDB.db.getStateIdByName(selectedState);
    String? cityId = cities.firstWhereOrNull((city) => city.cityName == selectedCity)?.cityId?.toString();

    if (countryId == null) {
      Get.snackbar(ConstantData.errorText, ConstantData.invalidLocation);
      return;
    }

    Map<String, dynamic> updateParams = {
      'user[countryId]': countryId,
    };

    if (stateId != null) {
      updateParams['user[stateId]'] = stateId;
    }
    if (cityId != null && cityId.isNotEmpty) {
      updateParams['user[cityId]'] = cityId;
    }

    await DioClient.instance.requestNetwork<void>(
      method: Method.post,
      url: ApiConstants.updateProfile,
      queryParameters: updateParams,
      options: Options(headers: {'token': tokenEntity.accessToken}),
      onSuccess: (data) async {
        await globalService.refreshUserData(tokenEntity.accessToken.toString());
        Get.offNamed(AppRoutes.meMyProfile, arguments: {
          'userDataEntity': globalService.userDataEntity.value,
          'tokenEntity': tokenEntity,
        });
      },
      onError: (code, msg, data) {
        Get.snackbar(ConstantData.failedText, msg);
      },
    );
  }
}

