import 'dart:collection';

import '../../pub/resource/package.dart';

class WorkivaPackageDartMetrics extends MapView {
  PackageResource _package;

  WorkivaPackageDartMetrics(PackageResource package, Map dartMetricsMap)
      : super(dartMetricsMap) {
    _package = package;
  }

  String get packageName => _package.name;

  int get files => this['files'];

  int get linesOfCode => this['lines'];

  int get blankLines => this['blanks'];

  int get linesOfComments => this['comments'];
}
