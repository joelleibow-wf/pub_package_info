import 'dart:async';

import './api.dart';
import './resource/package.dart';

class PubService {
  PubApi _pubApi;

  PubService({pubServerHost}) {
    _pubApi = new PubApi(pubServerHost ?? 'https://pub.dartlang.org');
  }

  Future<PackageResource> getPackage(Map packageConfig) async {
    final package = await _pubApi.getPackageInfo(packageConfig['name']);

    return (package != null)
        ? new PackageResource(package..addAll(packageConfig))
        : null;
  }
}
