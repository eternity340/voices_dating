import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceUtils {
  static getBuildNo() async {
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    return _packageInfo.buildNumber;
  }

  static getVersion() async {
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    return _packageInfo.version;
  }

  static getUUID() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    const androidIdPlugin = AndroidId();
    String identifier = "";
    if (Platform.isAndroid) {
      String? androidID = await androidIdPlugin.getId();
      identifier = androidID ?? ""; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      identifier = data.identifierForVendor ?? ""; //UUID for iOS
    }
    return identifier;
  }

  static getPackageName() async {
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    return _packageInfo.packageName;
  }

  static getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo deviceData = await deviceInfoPlugin.androidInfo;
        return deviceData;
      } else if (Platform.isIOS) {
        IosDeviceInfo deviceData = await deviceInfoPlugin.iosInfo;
        return deviceData;
      }
    } on PlatformException {
      return null;
    }
  }
}