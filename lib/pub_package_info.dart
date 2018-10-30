library pub_package_info;

import 'dart:async';

import './src/pub/resource/package.dart';
import './src/pub/service.dart';

export './src/pub/resource/package.dart';

Future<PackageResource> getPackageInfo(String packageName) async {
  PubService pubService = new PubService();

  return await pubService.getPackageInfo(packageName);
}

List versionsSupportingSdkVersion(PackageResource package, String sdkVersion) {
  PubService pubService = new PubService();

  return pubService.versionsSupportingSdkVersion(package, sdkVersion);
}
