library pub_package_info;

import 'dart:async';

import 'package:github/server.dart';
import 'package:pub_semver/pub_semver.dart';

import './src/pub/resource/package_version.dart';
import './src/pub/resource/package.dart';
import './src/pub/service.dart';
import './src/workiva_package_repository/model/workiva_package_dart_metrics.dart';
import './src/workiva_package_repository/service.dart';

Future<PackageResource> getPackage(Map packageConfig,
    {String pubServerHost}) async {
  final pubService = new PubService(pubServerHost: pubServerHost);

  return pubService.getPackage(packageConfig);
}

Future<PackageResource> getWorkivaPackage(Map packageConfig) async {
  return (packageConfig['isGitDependency'] != null &&
          packageConfig['isGitDependency'])
      ? new PackageResource(packageConfig)
      : await getPackage(packageConfig,
          pubServerHost: 'https://pub.workiva.org');
}

Future<WorkivaPackageDartMetrics> getWorkivaPackageDartMetrics(
    Map packageConfig) async {
  final package = (packageConfig['isPublicWorkivaPackage'] != null &&
          packageConfig['isPublicWorkivaPackage'])
      ? await getPackage(packageConfig)
      : await getWorkivaPackage(packageConfig);

  final workivaRepoService = new WorkivaPackageRepositoryService(package);
  return await workivaRepoService.getDartCodeMetrics();
}

Future<PullRequest> getWorkivaPackageDart2PullRequestMetrics(
    Map packageConfig) async {
  final package = (packageConfig['isPublicWorkivaPackage'] != null &&
          packageConfig['isPublicWorkivaPackage'])
      ? await getPackage(packageConfig)
      : await getWorkivaPackage(packageConfig);

  final workivaRepoService = new WorkivaPackageRepositoryService(package);
  return await workivaRepoService
      .getPullRequestData(package['dart2PullRequestUri']);
}

List getVersionsSupportingSdkVersion(
    PackageResource package, String sdkVersion) {
  final matchingVersions = package.versions
      .where((packageVersion) =>
          versionSupportsSdkVersion(packageVersion, sdkVersion))
      .toList()
        ..sort((packageVersionB, packageVersionA) {
          return new Version.parse(packageVersionB.version)
              .compareTo(new Version.parse(packageVersionA.version));
        });

  return matchingVersions;
}

bool versionSupportsSdkVersion(
    PackageVersionResource packageVersion, String sdkVersion) {
  if (packageVersion.sdkConstraint == null) return false;

  final requiredSdkVersion = new Version.parse(sdkVersion);
  final packageVersionSdkConstraint =
      new VersionConstraint.parse(packageVersion.sdkConstraint);

  // Assume that if max is `null` that it's an old version that doesn't actually support Dart2.
  // ignore: undefined_getter
  if (packageVersionSdkConstraint.max != null) {
    return packageVersionSdkConstraint.allows(requiredSdkVersion);
  }

  return false;
}
