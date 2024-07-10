import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../entity/User.dart';
import '../location_box.dart';


class LocationSelector extends StatefulWidget {
  final User user;
  final Function(String? country, String? state, String? city) onLocationSelected;

  LocationSelector({required this.user, required this.onLocationSelected});

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  void updateLocation({String? country, String? state, String? city}) {
    setState(() {
      if (country != null) selectedCountry = country;
      if (state != null) selectedState = state;
      if (city != null) selectedCity = city;
      widget.onLocationSelected(selectedCountry, selectedState, selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocationBox(
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
    );
  }
}
