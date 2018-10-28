import 'dart:collection';

class PackageMeta extends MapView {
  PackageMeta(Map map) : super(map);

  Iterable<Map> get versions => this['versions'];
}
