import 'package:pub_package_info/pub_package_info.dart';

main() async {
  var packageInfo = await getPackageInfo('intl');

  print((packageInfo == null)
      ? 'The package "intl" was not found.'
      : packageInfo);
}

// import 'package:http/http.dart' as http;
// import 'package:pub_semver/pub_semver.dart' as ps;

// Future<PackageMeta> loadPackageMeta(String packageName,
//     {String host: 'https://pub.dartlang.org'}) async {
//   var response = await http.get('$host/api/packages/$packageName');
//   return new PackageMeta(JSON.decode(response.body));
// }

// Map resolveVersionConstraint(PackageMeta package,
//     ps.VersionConstraint constraint, ps.Version sdkVersion) {
//   var matchingVersions = package.versions.where((packageVersion) {
//     var version = new ps.Version.parse(packageVersion['version']);

//     return constraint.allows(version);
//   }).toList()
//     ..sort((packageVersionA, packageVersionB) {
//       return new ps.Version.parse(packageVersionB['version'])
//           .compareTo(new ps.Version.parse(packageVersionA['version']));
//     });

//   return matchingVersions.firstWhere((packageVersion) {
//     String sdkConstraint;
//     var env = packageVersion['pubspec']['environment'];

//     if (env != null) sdkConstraint = env['sdk'];

//     return (sdkConstraint == null) &&
//         new ps.VersionConstraint.parse(sdkConstraint).allows(sdkVersion);
//   }, orElse: () => null);
// }
