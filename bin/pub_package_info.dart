import 'package:pub_package_info/pub_package_info.dart';

import '../tool/wdesk_deps.dart';

main() async {
  // await _getDart2CompatiblePublicWdeskDependencies();
  await _getInternalWdeskDependencyDartMetrics();
}

_getDart2CompatiblePublicWdeskDependencies() async {
  final dartSdkConstraint = '2.0.0';
  final wdeskPublicDependencies = getPublicWdeskDependencies().values.toList();
  var package;

  for (var i = 0; i < wdeskPublicDependencies.length; i++) {
    package = await getPackage(wdeskPublicDependencies[i]);

    var dart2SupportingVersions =
        versionsSupportingSdkVersion(package, dartSdkConstraint);

    // Print some output for copying and pasting into a Google Sheet.
    if (dart2SupportingVersions.isEmpty) {
      // Only print the package name if there's no versions indicating support for Dart2.
      print(package.name);
    } else {
      // Print the package name w/ its first supporting Dart2 version.
      print('${package.name}\t${dart2SupportingVersions.first.version}');
    }
  }
}

_getInternalWdeskDependencyDartMetrics() async {
  final wdeskInternalDependencies =
      getInternalWdeskDependencies().values.toList();
  var packageMetrics;

  for (var i = 0; i < wdeskInternalDependencies.length; i++) {
    packageMetrics =
        await getWorkivaPackageMetrics(wdeskInternalDependencies[i]);

    if (packageMetrics != null) {
      print(
          '${packageMetrics.packageName}\t${packageMetrics.files}\t${packageMetrics.linesOfCode}\t${packageMetrics.blankLines}\t${packageMetrics.linesOfComments}');
    } else {
      print(wdeskInternalDependencies[i]['name']);
    }
  }
}
