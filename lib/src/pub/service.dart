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
    var requiredSdkVersion = new Version.parse(sdkVersionRequirement);

    var matchingVersions = package.versions.where((packageVersion) {
      if (packageVersion.sdkConstraint != null) {
        var packageVersionSdkConstraint =
            new VersionConstraint.parse(packageVersion.sdkConstraint);

        return packageVersionSdkConstraint.allows(requiredSdkVersion);
      }

      return false;
    }).toList();

    return matchingVersions;
  }
}
