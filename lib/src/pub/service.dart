import 'dart:async';

import 'package:pub_semver/pub_semver.dart';

import './api.dart';
import './resource/package.dart';
import './resource/package_version.dart';

class PubService {
  final PubApi _pubApi = new PubApi();

  Future<PackageResource> getPackageInfo(String packageName) async {
    var packageMeta = await _pubApi.getPackageInfo(packageName);

    return (packageMeta != null) ? new PackageResource(packageMeta) : null;
  }

  /**
   * Returns a [List] of [PackageVersionResource] whose SDK constraint includes
   * the provided SDK version. The returned [List] will be sorted from the
   * earliest to the latest release.
   */
  List<PackageVersionResource> versionsSupportingSdkVersion(
      PackageResource package, String sdkVersionRequirement) {
    var requiredSdkVersion = new Version.parse(sdkVersionRequirement);

    var matchingVersions = package.versions.where((packageVersion) {
      if (packageVersion.sdkConstraint != null) {
        var packageVersionSdkConstraint =
            new VersionConstraint.parse(packageVersion.sdkConstraint);

        // Assume that if max is `null` that it's an old version that doesn't actually support Dart2.
        if (packageVersionSdkConstraint.max != null) {
          return packageVersionSdkConstraint.allows(requiredSdkVersion);
        }

        return false;
      }

      return false;
    }).toList()
      ..sort((packageVersionB, packageVersionA) {
        return new Version.parse(packageVersionB.version)
            .compareTo(new Version.parse(packageVersionA.version));
      });

    return matchingVersions;
  }
}
