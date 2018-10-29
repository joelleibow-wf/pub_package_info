import 'dart:collection';

import './package_version.dart';

class PackageResource extends MapView {
  PackageResource(Map map) : super(map);

  PackageVersionResource get latest =>
      new PackageVersionResource(this['latest']['version']);

  String get name => this['name'];

  Iterable<PackageVersionResource> get versions => this['versions']
      .map((packageVersion) => new PackageVersionResource(packageVersion))
      .toList();
}
