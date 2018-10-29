import 'dart:async';

import 'package:pub_semver/pub_semver.dart';

import './api.dart';
import './resource/package.dart';

class PubService {
  final PubApi _pubApi = new PubApi();

  Future<PackageResource> getPackageInfo(String packageName) async {
    return new PackageResource(await _pubApi.getPackageInfo(packageName));
  }

  List versionsSupportingSdkVersion(
      PackageResource package, String sdkVersionRequirement) {
    var sdkVersion = new Version.parse(sdkVersionRequirement);

    var matchingVersions = package.versions.where((packageVersion) {
      if (packageVersion.containsKey('pubspec') &&
          packageVersion['pubspec'].containsKey('environment') &&
          packageVersion['pubspec']['environment'].containsKey('sdk')) {
        var packageVersionSdkConstraint = new VersionConstraint.parse(
            packageVersion['pubspec']['environment']['sdk']);
        return packageVersionSdkConstraint.allows(sdkVersion);
      }

      return false;
    }).toList();

    return matchingVersions;
  }
}
