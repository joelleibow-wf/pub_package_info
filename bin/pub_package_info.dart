import 'package:pub_package_info/pub_package_info.dart';

import '../tool/wdesk_deps.dart';

main() async {
  // await _getDart2CompatiblePublicWdeskDependencies();
  await _getInternalWdeskDependencyDartMetrics();
  // await _getInternalWdeskDependencyDart2PullRequestMetrics();
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

_getInternalWdeskDependencyDart2PullRequestMetrics() async {
  final dart2CompatibleInternalWdeskDependencies =
      getInternalWdeskDependencies()
          .values
          .where(
              (packageConfig) => packageConfig['dart2PullRequestUri'] != null)
          .toList();
  var pullRequest;

  for (var i = 0; i < dart2CompatibleInternalWdeskDependencies.length; i++) {
    pullRequest = await getWorkivaPackageDart2PullRequestMetrics(
        dart2CompatibleInternalWdeskDependencies[i]);

    print(
        '\t${pullRequest.changedFilesCount}\t${pullRequest.additionsCount}\t${pullRequest.deletionsCount}\t${pullRequest.createdAt}\t${pullRequest.mergedAt}');
  }
}
