import 'dart:async';

import 'package:dloc/dloc_base.dart';

import './model/workiva_package_dart_metrics.dart';
import './model/workiva_package_repository.dart';
import '../pub/resource/package.dart';

class WorkivaPackageRepositoryService {
  WorkivaRepository _repository;
  PackageResource _package;

  WorkivaPackageRepositoryService(this._package) {
    _repository = new WorkivaRepository(Uri.parse(_package.repositoryUri));
  }

  Future<WorkivaPackageDartMetrics> getDartCodeMetrics() async {
    if (!_repository.isCloned) await _repository.clone();

    initialize(
        new CommandLineArgs(parser.parse([_repository.cloneDirectory.path])),
        silenceLogger: true);
    final locResult = countLinesOfCode(_repository.cloneDirectory.path);
    final dartCodeMetrics = locResult.data[hasMatch('main.dart').ext];

    return new WorkivaPackageDartMetrics(_package, {
      'files': dartCodeMetrics.files,
      'lines': dartCodeMetrics.lines,
      'blanks': dartCodeMetrics.blanks,
      'comments': dartCodeMetrics.comments
    });
  }
}
