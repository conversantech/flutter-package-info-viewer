import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/foundation.dart';

class AppPackageInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  AppPackageInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });
}

class DeviceInfoData {
  final String model;
  final String osVersion;
  final String? batteryLevel;
  final String? ipAddress;

  DeviceInfoData({
    required this.model,
    required this.osVersion,
    this.batteryLevel,
    this.ipAddress,
  });
}

class PackageInfoService {
  static Future<AppPackageInfo> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return AppPackageInfo(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }

  static Future<DeviceInfoData> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final Battery battery = Battery();
    final NetworkInfo networkInfo = NetworkInfo();

    String model = "Unknown";
    String osVersion = "Unknown";

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      model = webBrowserInfo.browserName.name;
      osVersion = webBrowserInfo.userAgent ?? "Unknown";
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      model = androidInfo.model;
      osVersion = "Android ${androidInfo.version.release}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      model = iosInfo.utsname.machine;
      osVersion = "iOS ${iosInfo.systemVersion}";
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
      model = macInfo.model;
      osVersion = "macOS ${macInfo.osRelease}";
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
      model = windowsInfo.productName;
      osVersion = windowsInfo.displayVersion;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
      model = linuxInfo.name;
      osVersion = linuxInfo.version ?? "Unknown";
    }

    String? batteryLevel;
    try {
      int level = await battery.batteryLevel;
      batteryLevel = "$level%";
    } catch (_) {}

    String? ipAddress;
    try {
      ipAddress = await networkInfo.getWifiIP();
    } catch (_) {}

    return DeviceInfoData(
      model: model,
      osVersion: osVersion,
      batteryLevel: batteryLevel,
      ipAddress: ipAddress,
    );
  }
}
