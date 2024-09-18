import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import 'components/widget/location_selector.dart';
import '../../../constants/constant_data.dart';
import '../../../constants/constant_styles.dart';
import '../../../storage/location_data_db.dart';

class SelectLocationPage extends StatefulWidget {
  final User user;

  SelectLocationPage({Key? key, required this.user}) : super(key: key);

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  int? selectedCountryId;
  int? selectedStateId;
  String? selectedCityId;

  void onLocationSelected(String? country, String? state, String? city, String? cityId) {
    setState(() {
      selectedCountry = country;
      selectedState = state;
      selectedCity = city;
      selectedCityId = cityId;
      _updateIds();
    });
  }

  Future<void> _updateIds() async {
    if (selectedCountry != null) {
      selectedCountryId = await LocationDataDB.db.getCountryIdByName(selectedCountry!);
    }
    if (selectedState != null) {
      selectedStateId = await LocationDataDB.db.getStateIdByName(selectedState!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                Text(
                  ConstantData.locationTitle,
                  style: ConstantStyles.locationTitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                LocationSelector(
                  user: widget.user,
                  onLocationSelected: onLocationSelected,
                ),
                SizedBox(height: 350.h),
                GradientButton(
                  text: ConstantData.continueButtonText,
                  onPressed: () {
                    widget.user.country = selectedCountryId.toString();
                    widget.user.state = selectedStateId.toString();
                    widget.user.city = selectedCityId;
                    Get.toNamed('/select_birthday', arguments: widget.user);
                  },
                  width: 200.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
