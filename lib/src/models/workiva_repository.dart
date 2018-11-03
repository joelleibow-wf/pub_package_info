import 'dart:async';
import 'dart:io';

import 'package:dotenv/dotenv.dart' show env, load;
import 'package:git/git.dart';
import 'package:github/server.dart';

import '../constants.dart';

class WorkivaRepository {
  GitHub _github;
  Repository _repo;
  RepositorySlug _repoSlug;

  WorkivaRepository(Uri workivaGithubUri) {
    _repoSlug = new RepositorySlug(
        'Workiva', workivaGithubUri.path.replaceFirst("/Workiva/", ""));

    load();
    _github = createGitHubClient(
        auth: new Authentication.withToken(env['GITHUB_API_TOKEN']));
  }

  Future<ProcessResult> clone() async {
    await _fetchRepository();

    return await runGit(['clone', '--depth', '1', _repo.cloneUrls.ssh],
        processWorkingDir: REPOSITORY_DIRECTORY);
  }

  _fetchRepository() async {
    if (_repo == null)
      _repo = await _github.repositories.getRepository(_repoSlug);
  }
}
