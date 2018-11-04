library pub_package_info;

import 'dart:async';

import './src/pub/resource/package.dart';
import './src/pub/service.dart';
import './src/repository/service.dart';

export './src/pub/resource/package.dart';

Future<PackageResource> getPackage(Map packageConfig,
    {String pubServerHost}) async {
  final pubService = new PubService(pubServerHost: pubServerHost);

  return pubService.getPackage(packageConfig);
}

Future<PackageResource> getWorkivaPackage(Map packageConfig) async {
  return await getPackage(packageConfig,
      pubServerHost: 'https://pub.workiva.org');
}

Future<Map<String, int>> getWorkivaPackageMetrics(Map packageConfig) async {
  final package = await getWorkivaPackage(packageConfig);

  if (package != null && package.isWorkivaPackage) {
    final workivaRepoService = new WorkivaRepositoryService();
    final workivaPackageRepo = workivaRepoService.getPackageRepository(package);

    await workivaPackageRepo.clone();
    return await workivaPackageRepo.dartCodeMetrics();
  }

  return null;
}

List versionsSupportingSdkVersion(PackageResource package, String sdkVersion) {
  return new PubService().versionsSupportingSdkVersion(package, sdkVersion);
}
