import 'package:dio/dio.dart';
import 'package:first_app/service/token_service.dart';
import 'package:first_app/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/User.dart';
import '../../../../components/background.dart';
import '../../../../entity/city_entity.dart';
import '../../../../image_res/image_res.dart';
import '../../../../net/api_constants.dart';
import '../../../../net/dio.client.dart';
import '../../../../storage/location_data_db.dart';

class LocationDetailPage extends StatefulWidget {



  const LocationDetailPage({Key? key, }) : super(key: key);

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  String selectedCountry = ConstantData.selectedCountry;
  String selectedState = ConstantData.selectedState;
  String selectedCity = ConstantData.selectedCity;
  String? selectedCityId;
  int? selectedStateId;
  List<CityEntity> cities = [];
  bool isCityLoading = false;

  @override
  Widget build(BuildContext context) {
    return Background(
      showBackgroundImage: false,
      showBackButton: true,
      showMiddleText: true,
      middleText: ConstantData.locationHeaderTitle,
      child: Stack(
        children: [
          Positioned(
            top: 0.h,
            right: 20.w,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
                ),
                borderRadius: BorderRadius.circular(24.5.r),
              ),
              width: 88.w,
              height: 36.h,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'country': selectedCountry,
                    'state': selectedState,
                    'city': selectedCity,
                    'cityId': selectedCityId,
                  });
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 80.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              children: [
                _buildLocationBox(
                    'Country: $selectedCountry',
                    ImageRes.imagePathBackButton,
                    ConstantData.countryText),
                SizedBox(height: 20.h),
                _buildLocationBox(
                    'State: $selectedState'
                    ,ImageRes.imagePathBackButton,
                    ConstantData.stateText),
                SizedBox(height: 20.h),
                _buildLocationBox(
                    'City: $selectedCity',
                    ImageRes.imagePathBackButton,
                    ConstantData.cityText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBox(String text, String iconPath, String type) {
    bool isEnabled = type == 'country' ||
        (type == 'state' && selectedCountry != ConstantData.selectedCountry) ||
        (type == 'city' && selectedState != ConstantData.selectedState && !isCityLoading);

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
                if (type == 'city' && isCityLoading)
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
      Container(
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Select ${type.capitalize}',
                style: ConstantStyles.selectLocationStyle,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1.h,
                  color: Colors.grey[300],
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      type == 'city' ? cities[index].cityName! : items[index].toString(),
                      style: ConstantStyles.locationListStyle,
                    ),
                    onTap: () {
                      setState(() {
                        if (type == 'country') {
                          selectedCountry = items[index].toString();
                          selectedState = ConstantData.selectedState;
                          selectedCity = ConstantData.selectedCity;
                          selectedCityId = null;
                          cities.clear();
                        } else if (type == 'state') {
                          selectedState = items[index].toString();
                          selectedCity = ConstantData.selectedCity;
                          selectedCityId = null;
                          _getStateId(selectedState);
                        } else if (type == 'city') {
                          selectedCity = cities[index].cityName!;
                          selectedCityId = cities[index].cityId;
                        }
                      });
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.transparent,
    );
  }



  Future<List<String>> _getItemsByType(String type) async {
    if (type == 'country') {
      return (await LocationDataDB.db.getCountries).map((country) => country.couName!).toList();
    } else if (type == 'state') {
      if (selectedCountry != ConstantData.selectedCountry) {
        int countryId = await LocationDataDB.db.getCountryIdByName(selectedCountry) ?? -1;
        if (countryId != -1) {
          return (await LocationDataDB.db.getStatesListById(countryId)).map((state) => state.sttName!).toList();
        }
      }
    } else if (type == 'city') {
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
      options: Options(headers: {'token':await TokenService.instance.getToken()}),
      onSuccess: (data) {
        if (data != null) {
          setState(() {
            cities = data;
          });
        }
      },
      onError: (code, msg, data) {
        LogUtil.e(message: msg);
      },
    );
  }
}