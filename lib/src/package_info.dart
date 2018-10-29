import 'dart:collection';

class PackageInfo extends MapView {
  PackageInfo(Map map) : super(map);

  Iterable<Map> get versions => this['versions'];
}
