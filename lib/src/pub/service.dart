import 'dart:async';

import 'package:pub_semver/pub_semver.dart';

import './api.dart';
import './resource/package.dart';
import './resource/package_version.dart';

class PubService {
  PubApi _pubApi;

  PubService({pubServerHost}) {
    _pubApi = new PubApi(pubServerHost ?? 'https://pub.dartlang.org');
  }

  Future<PackageResource> getPackage(Map packageConfig) async {
    final package = await _pubApi.getPackageInfo(packageConfig['name']);

    return (package != null)
        ? new PackageResource(package..addAll(packageConfig))
        : null;
  }

  /**
   * Returns a [List] of [PackageVersionResource] whose SDK constraint includes
   * the provided SDK version. The returned [List] will be sorted from the
   * earliest to the latest release.
   */
  List<PackageVersionResource> versionsSupportingSdkVersion(
      PackageResource package, String sdkVersionRequirement) {
    final requiredSdkVersion = new Version.parse(sdkVersionRequirement);

    final matchingVersions = package.versions.where((packageVersion) {
      if (packageVersion.sdkConstraint != null) {
        final packageVersionSdkConstraint =
            new VersionConstraint.parse(packageVersion.sdkConstraint);

        // Assume that if max is `null` that it's an old version that doesn't actually support Dart2.
        // ignore: undefined_getter
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
