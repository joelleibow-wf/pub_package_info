import 'dart:collection';

import './package_version.dart';

class PackageResource extends MapView {
  PackageVersionResource _latestVersion;
  List<PackageVersionResource> _versions;

  PackageResource(Map map) : super(map);

  PackageVersionResource get latest {
    if (_latestVersion == null) {
      _latestVersion = new PackageVersionResource(this['latest']);
    }

    return _latestVersion;
  }

  String get name => this['name'];

  List<PackageVersionResource> get versions {
    if (_versions == null) {
      this['versions']
          .map((packageVersion) => new PackageVersionResource(packageVersion))
          .toList();
    }

    return _versions;
  }

  bool get isWorkivaPackage => latest.homepage.contains('Workiva');
}
