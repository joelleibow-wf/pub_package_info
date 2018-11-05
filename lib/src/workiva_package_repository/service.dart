import 'dart:async';
import 'dart:io';

import 'package:dloc/dloc_base.dart';
import 'package:git/git.dart';

import '../constants.dart';
import '../pub/resource/package.dart';
import './model/workiva_package_dart_metrics.dart';
import './model/workiva_package_repository.dart';

class WorkivaPackageRepositoryService {
  WorkivaRepository _workivaRepository;
  PackageResource _package;

  WorkivaPackageRepositoryService(this._package) {
    _workivaRepository =
        new WorkivaRepository(Uri.parse(_package.repositoryUri));
  }

  Future<Directory> checkout() async {
    if (!_workivaRepository.isLoaded) _workivaRepository.fetch();
    _workivaRepository.checkoutDirectory =
        new Directory('${REPOSITORY_DIRECTORY}/${_workivaRepository.name}');

    if (!_workivaRepository.hasCheckout) {
      await runGit(['clone', '--depth', '1', _workivaRepository.cloneUrls.ssh],
          processWorkingDir: REPOSITORY_DIRECTORY);
    }

    return _workivaRepository.checkoutDirectory;
  }

  Future<WorkivaPackageDartMetrics> getDartCodeMetrics() async {
    final _repoDirPath = (!_workivaRepository.hasCheckout)
        ? (await checkout()).path
        : _workivaRepository.checkoutDirectory.path;

    initialize(new CommandLineArgs(parser.parse([_repoDirPath])),
        silenceLogger: true);
    final locResult = countLinesOfCode(_repoDirPath);
    final dartCodeMetrics = locResult.data[hasMatch('main.dart').ext];

    return new WorkivaPackageDartMetrics(_package, {
      'files': dartCodeMetrics.files,
      'lines': dartCodeMetrics.lines,
      'blanks': dartCodeMetrics.blanks,
      'comments': dartCodeMetrics.comments
    });
  }
}
