/*
import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:voices_dating/entity/current_location_entity.dart';
import 'package:voices_dating/net/dio.client.dart';
import '../entity/location_entity.dart';
import '../net/api_constants.dart';

class LocationService extends GetxService {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final DioClient dioClient = DioClient.instance;
  Rx<CurrentLocationEntity?> currentLocation = Rx<CurrentLocationEntity?>(null);

  Future<bool> initialize() async {
    bool hasPermission = await _handlePermission();
    if (hasPermission) {
      await getCurrentPosition();
    }
    return hasPermission;
  }

  Future<void> getCurrentPosition() async {
    try {
      Position position = await _geolocatorPlatform.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
          //localeIdentifier: "en"
      );

      if (placemarks.isNotEmpty) {
        CurrentLocationEntity currentLocationEntity = CurrentLocationEntity(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
          couName: placemarks.first.country,
          sttName: placemarks.first.administrativeArea,
          citName: placemarks.first.locality,
        );
        currentLocation.value = currentLocationEntity;
        await _uploadLocation(currentLocationEntity);
      }
    } catch (e) {
      print("Error getting current position: $e");
      // 可以在这里添加错误处理逻辑
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 可以在这里添加提示用户开启位置服务的逻辑
      return false;
    }

    LocationPermission permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 可以在这里添加提示用户在设置中开启权限的逻辑
      return false;
    }

    return true;
  }

  Future<void> _uploadLocation(CurrentLocationEntity currentLocationEntity) async {
    try {
      await DioClient.instance.requestNetwork<bool>(
        method: Method.post,
        url: ApiConstants.updateUserLocation,
        params: {
          'longitude': currentLocationEntity.longitude,
          'latitude': currentLocationEntity.latitude,
          'curAddress': currentLocationEntity.toAddress(),
        },
        onSuccess: (data) {
          print("Location uploaded successfully");
        },
        onError: (code, message, data) {
          print("Error uploading location: $message");
        },
      );
    } catch (e) {
      print("Exception during location upload: $e");
    }
  }
}
*/
