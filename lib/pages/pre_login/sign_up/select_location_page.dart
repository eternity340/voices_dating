import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../entity/User.dart';
import '../../../../constants.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import 'components/location_box.dart';

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

  void updateLocation({String? country, String? state, String? city}) {
    setState(() {
      if (country != null) selectedCountry = country;
      if (state != null) selectedState = state;
      if (city != null) selectedCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    height: 44 / 32,
                    letterSpacing: -0.02,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                LocationBox(
                  text: 'State: ${selectedState ?? "Select State"}, Country: ${selectedCountry ?? "Select Country"}',
                  onTap: () async {
                    final result = await Get.toNamed('/location_detail', arguments: widget.user);
                    if (result != null) {
                      updateLocation(
                        country: result['country'],
                        state: result['state'],
                        city: result['city'],
                      );
                    }
                  },
                ),
                SizedBox(height: 400),
                GradientButton(
                  text: "Continue",
                  onPressed: () {
                    widget.user.country = selectedCountry;
                    widget.user.state = selectedState;
                    widget.user.city = selectedCity;
                    Get.toNamed('/select_birthday', arguments: widget.user);
                  },
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
