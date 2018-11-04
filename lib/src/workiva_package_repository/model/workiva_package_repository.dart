import 'dart:io';

import 'package:dotenv/dotenv.dart' show env, load;
import 'package:git/git.dart';
import 'package:github/server.dart';

import '../../constants.dart';

class WorkivaRepository {
  Directory _cloneDir;
  GitHub _github;
  bool _isCloned = false;
  Repository _repo;
  RepositorySlug _repoSlug;

  WorkivaRepository(Uri workivaGithubUri) {
    final repoName = workivaGithubUri.path.replaceFirst('/Workiva/', '');
    _repoSlug = new RepositorySlug(
        'Workiva', repoName.replaceFirst('/', '', (repoName.length - 1)));
  }

  bool get isLoaded => (_repo != null);

  bool get isCloned => _isCloned;

  Directory get cloneDirectory => _cloneDir;

  clone() async {
    await _fetchRepository();
    _cloneDir = new Directory('${REPOSITORY_DIRECTORY}/${_repo.name}');
    _isCloned = await _cloneDir.exists();

    if (!isCloned) {
      await runGit(['clone', '--depth', '1', _repo.cloneUrls.ssh],
          processWorkingDir: REPOSITORY_DIRECTORY);

      _isCloned = await _cloneDir.exists();
    }
  }

  _fetchRepository() async {
    if (!isLoaded) {
      load();
      _github = createGitHubClient(
          auth: new Authentication.withToken(env['GITHUB_API_TOKEN']));

      _repo = await _github.repositories.getRepository(_repoSlug);
    }
  }
}
