library pub_package_info;

import 'dart:async';

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
  return await getPackage(packageConfig,
      pubServerHost: 'https://pub.workiva.org');
}

Future<WorkivaPackageDartMetrics> getWorkivaPackageDartMetrics(
    Map packageConfig) async {
  var package;

  if (packageConfig['isGitDependency'] != null &&
      packageConfig['isGitDependency']) {
    package = new PackageResource(packageConfig);
  } else {
    package = (packageConfig['isPublicWorkivaPackage'] != null &&
            packageConfig['isPublicWorkivaPackage'])
        ? await getPackage(packageConfig)
        : await getWorkivaPackage(packageConfig);
  }

  if (package != null && package.isWorkivaPackage) {
    final workivaRepoService = new WorkivaPackageRepositoryService(package);

    return await workivaRepoService.getDartCodeMetrics();
  }

  return null;
}

List versionsSupportingSdkVersion(PackageResource package, String sdkVersion) {
  return new PubService().versionsSupportingSdkVersion(package, sdkVersion);
}
