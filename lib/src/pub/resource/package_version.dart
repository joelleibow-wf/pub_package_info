import 'dart:collection';

class PackageVersionResource extends MapView {
  dynamic _pubspec;

  PackageVersionResource(Map map) : super(map) {
    this._pubspec = this['pubspec'];
  }

  String get sdkConstraint {
    return (_pubspec['environment'] != null)
        ? _pubspec['environment']['sdk']
        : null;
  }

  String get homepage => _pubspec['homepage'];

  String get name => _pubspec['name'];

  String get version => _pubspec['version'];
}
