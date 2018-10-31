import 'package:pub_package_info/pub_package_info.dart';

import '../tool/wdesk_deps.dart';

main() async {
  String dartSdkConstraint = '2.0.0';
  PackageResource package;

  for (var i = 0; i < wdeskPublicDependencies.length; i++) {
    package = await getPackageInfo(wdeskPublicDependencies[i]);

    if (package != null) {
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
}
