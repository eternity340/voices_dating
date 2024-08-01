import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import 'components/widget/location_selector.dart';
import '../../../constants/constant_data.dart'; // Import constant data
import '../../../constants/constant_styles.dart'; // Import constant styles

class SelectLocationPage extends StatefulWidget {
  final User user;

  SelectLocationPage({super.key, required this.user});

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  void onLocationSelected(String? country, String? state, String? city) {
    setState(() {
      selectedCountry = country;
      selectedState = state;
      selectedCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0.w), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h), // Responsive height
                Text(
                  ConstantData.locationTitle,
                  style: ConstantStyles.locationTitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h), // Responsive height
                LocationSelector(
                  user: widget.user,
                  onLocationSelected: onLocationSelected,
                ),
                SizedBox(height: 350.h), // Responsive height
                GradientButton(
                  text: ConstantData.continueButtonText,
                  onPressed: () {
                    widget.user.country = selectedCountry;
                    widget.user.state = selectedState;
                    widget.user.city = selectedCity;
                    Get.toNamed('/select_birthday', arguments: widget.user);
                  },
                  width: 200.w, // Responsive width
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
