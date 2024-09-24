/*
import 'dart:async';
import 'package:get/get.dart';
import '../entity/location_entity.dart';
import '../utils/log_util.dart';

class LocationService extends GetxService {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  // final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  Future<LocationEntity?> getCurrentPosition({bool showLoading = false}) async {
    final hasPermission = await handlePermission();

    LogUtil.logger.shout("getCurrentPosition getCurrentPosition111");
    if (!hasPermission) {
      return null;
    }
    LogUtil.logger.shout("getCurrentPosition getCurrentPosition22222");
    if (showLoading) {
      showLoadingDialog();
    }
    LocationEntity? locationEntity;
    try {
      final position = await _geolocatorPlatform.getCurrentPosition(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 1000,
        timeLimit: Duration(seconds: 15),
      ));

      LogUtil.logger.shout("getCurrentPosition end");
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: "en");

      if (placemarks.isNotEmpty) {
        LocationEntity locationBean = LocationEntity();
        for (var element in placemarks) {
          if (locationBean.country == null || locationBean.country!.isEmpty) {
            locationBean.country = element.country;
          }
          if (locationBean.state == null || locationBean.state!.isEmpty) {
            locationBean.state = element.administrativeArea;
          }
          if (locationBean.city == null || locationBean.city!.isEmpty) {
            locationBean.city = element.locality;
          }
        }
        locationBean.latitude = position.latitude.toString();
        locationBean.longitude = position.longitude.toString();
        await uploadLocation(locationBean);
        locationEntity = locationBean;
      }
    } catch (e) {
      LogUtil.logger.shout(e);
      LogUtil.logger.shout("getCurrentPosition $e");
    }

    ///获取last location
    if (locationEntity == null) {
      try {
        final position = await _geolocatorPlatform.getLastKnownPosition();
        if (position != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude,
              localeIdentifier: "en");

          if (placemarks.isNotEmpty) {
            LocationEntity locationBean = LocationEntity();
            for (var element in placemarks) {
              if (locationBean.country == null ||
                  locationBean.country!.isEmpty) {
                locationBean.country = element.country;
              }
              if (locationBean.state == null || locationBean.state!.isEmpty) {
                locationBean.state = element.administrativeArea;
              }
              if (locationBean.city == null || locationBean.city!.isEmpty) {
                locationBean.city = element.locality;
              }
            }
            locationBean.latitude = position.latitude.toString();
            locationBean.longitude = position.longitude.toString();
            await uploadLocation(locationBean);
            locationEntity = locationBean;
          }
        }
      } catch (e) {
        LogUtil.logger.shout(e);
      }
    }

    ///如果还是空,我们就用自带的吧
    if (locationEntity == null) {
      AuthService authService = Get.find();
      locationEntity = authService.currentAccount?.curLocation;
    } else {
      locationEntity.curAddress = locationEntity.toAddress();
    }
    if (showLoading) {
      hideLoading();
    }

    return locationEntity;
  }

  void _getLastKnownPosition() async {
    final position = await _geolocatorPlatform.getLastKnownPosition();
    if (position != null) {
      LogUtil.logger.shout("${position.toJson()}");
    } else {
      //TODO
    }
  }

  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  Future<void> uploadLocation(LocationEntity locationEntity) async {
    await DioUtils.instance.post<BoolEntity>(
        url: apiUpdateLocation,
        params: {
          'longitude': locationEntity.longitude,
          'latitude': locationEntity.latitude,
          'curAddress': locationEntity.toAddress(),
        },
        onSuccess: (data) {
          LogUtil.logger.shout(data);
        },
        onError: (code, message) {
          LogUtil.logger.shout(message);
        });
  }
}
*/
