import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../entity/User.dart';
import '../location_box.dart';

class LocationSelector extends StatefulWidget {
  final User user;
  final Function(String? country, String? state, String? city, String? cityId) onLocationSelected;

  LocationSelector({required this.user, required this.onLocationSelected});

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String? selectedCityId;

  void updateLocation({String? country, String? state, String? city, String? cityId}) {
    setState(() {
      selectedCountry = country;
      selectedState = state;
      selectedCity = city;
      selectedCityId = cityId;
      widget.onLocationSelected(selectedCountry, selectedState, selectedCity, selectedCityId);
    });
  }

  String _getDisplayText() {
    if (selectedCountry == null || selectedCountry == "Select Country") {
      return "Select location";
    }

    List<String> parts = [];
    if (selectedCity != null && selectedCity != "Select City") {
      parts.add(selectedCity!);
    }
    if (selectedState != null && selectedState != "Select State") {
      parts.add(selectedState!);
    }
    parts.add(selectedCountry!);

    return parts.join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return LocationBox(
      text: _getDisplayText(),
      onTap: () async {
        final result = await Get.toNamed('/location_detail', arguments: widget.user);
        if (result != null) {
          updateLocation(
            country: result['country'],
            state: result['state'],
            city: result['city'],
            cityId: result['cityId'],
          );
        }
      },
    );
  }
}
