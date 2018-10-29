import 'package:pub_package_info/pub_package_info.dart';

main() async {
  var dart2SupportingVersions =
      await versionsSupportingSdkVersion('intl', '2.0.0');

  if (dart2SupportingVersions == null) {
    print('The package "intl" was not found.');
  } else {
    var firstDart2Version = dart2SupportingVersions.first;
    print(
        '"${firstDart2Version.name}" version "${firstDart2Version.version}" supports SDK "2.0.0" with constaint "${firstDart2Version.sdkConstraint}"');
  }
}
