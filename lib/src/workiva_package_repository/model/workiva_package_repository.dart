import 'dart:async';
import 'dart:io';

import 'package:dotenv/dotenv.dart' show env, load;
import 'package:github/server.dart';

class WorkivaRepository {
  Directory _checkoutDirectory;
  GitHub _githubClient;
  Repository _repository;
  RepositorySlug _repositorySlug;

  WorkivaRepository(Uri workivaGithubUri) {
    final repoName = workivaGithubUri.path.replaceFirst('/Workiva/', '');
    _repositorySlug = new RepositorySlug(
        'Workiva', repoName.replaceFirst('/', '', (repoName.length - 1)));
  }

  Directory get checkoutDirectory => _checkoutDirectory;

  set checkoutDirectory(Directory directory) => _checkoutDirectory = directory;

  CloneUrls get cloneUrls => _repository?.cloneUrls;

  bool get hasCheckout => _checkoutDirectory?.existsSync();

  bool get isLoaded => (_repository != null);

  String get name => _repository?.name;

  fetch() async {
    if (!isLoaded) {
      _loadGithubClient();

      _repository =
          await _githubClient.repositories.getRepository(_repositorySlug);
    }
  }

  Future<PullRequest> fetchPullRequest(int pullRequestNumber) async {
    _loadGithubClient();

    return await _githubClient.pullRequests
        .get(_repositorySlug, pullRequestNumber);
  }

  _loadGithubClient() {
    if (_githubClient == null) {
      load();
      _githubClient = createGitHubClient(
          auth: new Authentication.withToken(env['GITHUB_API_TOKEN']));
    }
  }
}
