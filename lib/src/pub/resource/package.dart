import 'dart:collection';

import './package_version.dart';

class PackageResource extends MapView {
  PackageVersionResource _latestVersion;
  List<PackageVersionResource> _versions;

  PackageResource(Map map) : super(map);

  bool get isWorkivaPackage =>
      this['isPublicWorkivaPackage'] ?? repositoryUri.contains('Workiva');

  PackageVersionResource get latest {
    if (_latestVersion == null) {
      _latestVersion = new PackageVersionResource(this['latest']);
    }

    return _latestVersion;
  }

  String get name => this['name'];

  String get repositoryUri => this['repository'] ?? latest.homepage;

  List<PackageVersionResource> get versions {
    if (_versions == null) {
      _versions = this['versions']
          .map((packageVersion) => new PackageVersionResource(packageVersion))
          .toList();
    }

    return _versions;
  }
}
