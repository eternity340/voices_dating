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
                    text: 'Select a location',
                    onTap: () {
                      Get.toNamed('/location_detail', arguments: widget.user); // 跳转到 location_detail 页面
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
