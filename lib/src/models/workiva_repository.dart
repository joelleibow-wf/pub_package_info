import 'dart:async';
import 'dart:io';

import 'package:dloc/dloc_base.dart';
import 'package:dotenv/dotenv.dart' show env, load;
import 'package:git/git.dart';
import 'package:github/server.dart';

import '../constants.dart';

class WorkivaRepository {
  Directory _checkoutDir;
  Map<String, int> _dartCodeMetrics;
  GitHub _github;
  Repository _repo;
  RepositorySlug _repoSlug;

  WorkivaRepository(Uri workivaGithubUri) {
    final repoName = workivaGithubUri.path.replaceFirst('/Workiva/', '');
    _repoSlug = new RepositorySlug(
        'Workiva', repoName.replaceFirst('/', '', (repoName.length - 1)));
  }

  clone() async {
    await _fetchRepository();

    if (!(await _checkoutDir.exists())) {
      await runGit(['clone', '--depth', '1', _repo.cloneUrls.ssh],
          processWorkingDir: REPOSITORY_DIRECTORY);
    }
  }

  Future<Map<String, int>> dartCodeMetrics() async {
    if (_dartCodeMetrics == null) {
      await clone();

      initialize(new CommandLineArgs(parser.parse([_checkoutDir.path])),
          silenceLogger: true);
      final locResult = countLinesOfCode(_checkoutDir.path);
      final dartCodeMetrics = locResult.data[hasMatch('main.dart').ext];

      _dartCodeMetrics = {
        'files': dartCodeMetrics.files,
        'lines': dartCodeMetrics.lines,
        'blanks': dartCodeMetrics.blanks,
        'comments': dartCodeMetrics.comments
      };
    }

    return _dartCodeMetrics;
  }

  _fetchRepository() async {
    if (_repo == null) load();
    _github = createGitHubClient(
        auth: new Authentication.withToken(env['GITHUB_API_TOKEN']));

    _repo = await _github.repositories.getRepository(_repoSlug);

    _checkoutDir = new Directory('${REPOSITORY_DIRECTORY}/${_repo.name}');
  }
}
