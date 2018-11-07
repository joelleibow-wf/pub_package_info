import 'package:pub_package_info/pub_package_info.dart';

import '../tool/wdesk_deps.dart';

main() async {
  await _getPublicWdeskDependencyDart2Metrics();
  await _getInternalWdeskDependencyDartAndDart2PullRequestMetrics();
  // await _getInternalWdeskDependencyDart2PullRequestMetrics();
}

_getPublicWdeskDependencyDart2Metrics() async {
  final currentDartSdkConstraint = '1.24.3';
  final dartSdkConstraint = '2.0.0';
  final wdeskPublicDependencies =
      getPublicWdeskDependencies(withDeprecated: false).values.toList();
  var dart2SupportingVersion;
  var package;
  var output;
  var wdeskPackageVersion;

  for (var i = 0; i < wdeskPublicDependencies.length; i++) {
    package = await getPackage(wdeskPublicDependencies[i]);

    // Only print the package name if there's no versions indicating support for Dart2.
    output = '${package.name}\t${package.wdeskResolvedVersion}';

    wdeskPackageVersion = package.versions
        .firstWhere((pV) => pV.version == package.wdeskResolvedVersion);
    output +=
        '\t${(versionSupportsSdkVersion(wdeskPackageVersion, dartSdkConstraint) ? 'yes' : 'no')}';

    var dart2SupportingVersions =
        getVersionsSupportingSdkVersion(package, dartSdkConstraint);

    // Print some output for copying and pasting into a Google Sheet.
    if (!dart2SupportingVersions.isEmpty) {
      dart2SupportingVersion = dart2SupportingVersions.first;

      // Print the package name w/ its first supporting Dart2 version.
      output +=
          '\t${dart2SupportingVersion.version}\t${(versionSupportsSdkVersion(
          dart2SupportingVersion, currentDartSdkConstraint) ? 'yes' : 'no')}';
    }

    print(output);
  }
}

_getInternalWdeskDependencyDartAndDart2PullRequestMetrics() async {
  final wdeskInternalDependencies =
      getInternalWdeskDependencies().values.toList();
  var metricsOutput;
  var packageMetrics;
  var pullRequest;

  for (var i = 0; i < wdeskInternalDependencies.length; i++) {
    packageMetrics =
        await getWorkivaPackageDartMetrics(wdeskInternalDependencies[i]);
    // Print some output for copying and pasting into a Google Sheet.
    metricsOutput =
        '${packageMetrics.packageName}\t${packageMetrics.files}\t${packageMetrics.linesOfCode}\t${packageMetrics.blankLines}\t${packageMetrics.linesOfComments}';

    if (wdeskInternalDependencies[i]['dart2PullRequestUri'] != null) {
      pullRequest = await getWorkivaPackageDart2PullRequestMetrics(
          wdeskInternalDependencies[i]);
      metricsOutput +=
          '\t${pullRequest.changedFilesCount}\t${pullRequest.additionsCount}\t${pullRequest.deletionsCount}\t${pullRequest.createdAt}\t${pullRequest.mergedAt}';
    }

    print(metricsOutput);
  }
}

// _getInternalWdeskDependencyDart2PullRequestMetrics() async {
//   final dart2CompatibleInternalWdeskDependencies =
//       getInternalWdeskDependencies()
//           .values
//           .where(
//               (packageConfig) => packageConfig['dart2PullRequestUri'] != null)
//           .toList();
//   var pullRequest;

//   for (var i = 0; i < dart2CompatibleInternalWdeskDependencies.length; i++) {
//     pullRequest = await getWorkivaPackageDart2PullRequestMetrics(
//         dart2CompatibleInternalWdeskDependencies[i]);

//     print(
//         '\t${pullRequest.changedFilesCount}\t${pullRequest.additionsCount}\t${pullRequest.deletionsCount}\t${pullRequest.createdAt}\t${pullRequest.mergedAt}');
//   }
// }
