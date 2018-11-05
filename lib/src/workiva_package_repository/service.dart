import 'dart:async';
import 'dart:io';

import 'package:dloc/dloc_base.dart';
import 'package:git/git.dart';
import 'package:github/server.dart';

import '../constants.dart';
import '../pub/resource/package.dart';
import './model/workiva_package_dart_metrics.dart';
import './model/workiva_package_repository.dart';

class WorkivaPackageRepositoryService {
  WorkivaRepository _packageRepository;
  PackageResource _package;

  WorkivaPackageRepositoryService(this._package) {
    _packageRepository =
        new WorkivaRepository(Uri.parse(_package.repositoryUri));
  }

  Future<Directory> checkout() async {
    await _fetchRepositoryData();
    _packageRepository.checkoutDirectory =
        new Directory('${REPOSITORY_DIRECTORY}/${_packageRepository.name}');

    if (!_packageRepository.hasCheckout) {
      await runGit(['clone', '--depth', '1', _packageRepository.cloneUrls.ssh],
          processWorkingDir: REPOSITORY_DIRECTORY);
    }

    return _packageRepository.checkoutDirectory;
  }

  Future<WorkivaPackageDartMetrics> getDartCodeMetrics() async {
    final _repoDirPath = (!_packageRepository.hasCheckout)
        ? (await checkout()).path
        : _packageRepository.checkoutDirectory.path;

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

  Future<PullRequest> getPullRequestData(String pullRequestUri) async {
    await _fetchRepositoryData();

    return await _packageRepository.fetchPullRequest(
        int.parse(Uri.parse(pullRequestUri).path.split('/').last));
  }

  _fetchRepositoryData() async {
    if (!_packageRepository.isLoaded) await _packageRepository.fetch();
  }
}
