library pub_package_info;

import 'dart:async';

import './src/models/workiva_repository.dart';
import './src/pub/resource/package.dart';
import './src/pub/service.dart';

export './src/pub/resource/package.dart';

Future<PackageResource> getPackage(String packageName,
    {String pubServerHost}) async {
  final pubService = new PubService(pubServerHost: pubServerHost);

  return await pubService.getPackage(packageName);
}

Future<PackageResource> getWorkivaPackage(String packageName) async {
  return await getPackage(packageName,
      pubServerHost: 'https://pub.workiva.org');
}

Future<Map<String, int>> getWorkivaPackageMetrics(String packageName) async {
  final package = await getWorkivaPackage(packageName);

  if (package != null && package.isWorkivaPackage) {
    final workivaRepo =
        new WorkivaRepository(Uri.parse(package.latest.homepage));

    await workivaRepo.clone();
    return await workivaRepo.dartCodeMetrics();
  }

  return null;
}

List versionsSupportingSdkVersion(PackageResource package, String sdkVersion) {
  final pubService = new PubService();

  return pubService.versionsSupportingSdkVersion(package, sdkVersion);
}

// Future<List<RepositorySlug>> _getPackageRepoSlugs(
//     List<String> packageNames) async {
//   final pubService = new PubService(pubServerHost: 'https://pub.workiva.org');

//   var packageInfo;
//   final repoSlugs = [];
//   for (var package in packageNames) {
//     packageInfo = await pubService.getPackageInfo(package);

//     if (packageInfo != null &&
//         packageInfo.latest.homepage.contains('github.com/Workiva')) {
//       // We can always assume the second index to be the repo name.
//       repoSlugs.add(new RepositorySlug('Workiva',
//           Uri.parse(packageInfo.latest.homepage).path.split('/')[2]));
//     }
//   }

//   return repoSlugs;
// }
