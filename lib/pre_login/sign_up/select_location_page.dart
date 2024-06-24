import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../entity/User.dart';
import '../../../constants.dart';
import '../components/gradient_btn.dart';

class SelectLocationPage extends StatelessWidget {
  final User user;

  SelectLocationPage({required this.user});

  @override
  Widget build(BuildContext context) {
    String? selectedCountry;
    String? selectedState;
    String? selectedCity;

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCountry,
                items: ['Country1', 'Country2', 'Country3'] // 示例数据，实际应用中应从API获取
                    .map((country) => DropdownMenuItem(
                  value: country,
                  child: Text(country),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedCountry = value;
                },
                decoration: InputDecoration(labelText: "Select Country"),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedState,
                items: ['State1', 'State2', 'State3'] // 示例数据
                    .map((state) => DropdownMenuItem(
                  value: state,
                  child: Text(state),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedState = value;
                },
                decoration: InputDecoration(labelText: "Select State"),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCity,
                items: ['City1', 'City2', 'City3'] // 示例数据
                    .map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedCity = value;
                },
                decoration: InputDecoration(labelText: "Select City"),
              ),
              SizedBox(height: 20),
              GradientButton(
                text: "Continue",
                onPressed: () {
                  user.country = selectedCountry;
                  user.state = selectedState;
                  user.city = selectedCity;
                  Get.toNamed('/select_birthday', arguments: user);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
