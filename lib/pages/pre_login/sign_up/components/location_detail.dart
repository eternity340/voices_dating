import 'package:flutter/material.dart';
import '../../../../entity/User.dart';
import '../../../../components/background.dart';
import '../../../../storage/location_data_db.dart';

class LocationDetailPage extends StatefulWidget {
  final User user;

  const LocationDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  String selectedCountry = "Select Country";
  String selectedState = "Select State";
  String selectedCity = "Select City";

  void _showLocationSelection(BuildContext context, String type) async {
    final items = await _getItemsByType(type);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(items[index].toString()),
                onTap: () {
                  setState(() {
                    if (type == 'country') {
                      selectedCountry = items[index].toString();
                      selectedState = "Select State";
                      selectedCity = "Select City";
                    } else if (type == 'state') {
                      selectedState = items[index].toString();
                      selectedCity = "Select City";
                    } else if (type == 'city') {
                      selectedCity = items[index].toString();
                    }
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<List<String>> _getItemsByType(String type) async {
    if (type == 'country') {
      return (await LocationDataDB.db.getCountries).map((country) => country.couName!).toList();
    } else if (type == 'state') {
      if (selectedCountry != "Select Country") {
        int countryId = await LocationDataDB.db.getCountryIdByName(selectedCountry) ?? -1;
        if (countryId != -1) {
          return (await LocationDataDB.db.getStatesListById(countryId)).map((state) => state.sttName!).toList();
        }
      }
    } else if (type == 'city') {
      if (selectedState != "Select State") {
        int stateId = await LocationDataDB.db.getStateIdByName(selectedState) ?? -1;
        int countryId = await LocationDataDB.db.getCountryIdByName(selectedCountry) ?? -1;
        if (stateId != -1 && countryId != -1) {
          return (await LocationDataDB.db.getCitiesListById(stateId, countryId)).map((city) => city.cityName!).toList();
        }
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      showBackButton: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/back.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      const Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Location',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 22 / 18,
                    color: Colors.black,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(-8, 0, 0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
                    ),
                    borderRadius: BorderRadius.circular(24.5),
                  ),
                  width: 88,
                  height: 36,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop({
                        'country': selectedCountry,
                        'state': selectedState,
                        'city': selectedCity,
                      });
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
          _buildLocationBox('Country: $selectedCountry', 'assets/images/Path.png', 'country'),
          SizedBox(height: 20),
          _buildLocationBox('State: $selectedState', 'assets/images/Path.png', 'state'),
          SizedBox(height: 20),
          _buildLocationBox('City: $selectedCity', 'assets/images/Path.png', 'city'),
        ],
      ),
    );
  }

  Widget _buildLocationBox(String text, String iconPath, String type) {
    return GestureDetector(
      onTap: () {
        _showLocationSelection(context, type);
      },
      child: Container(
        width: 335,
        height: 69,
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Image.asset(
                iconPath,
                width: 10,
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
