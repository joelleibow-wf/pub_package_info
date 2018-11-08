import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import './resource/package.dart';

class PubService {
  final _uri = 'api/packages';
  String _host = 'https://pub.dartlang.org';

  PubService({pubServerHost}) {
    _host ??= pubServerHost;
  }

  Future<PackageResource> getPackage(Map packageConfig) async {
    final package = await _callApi(packageConfig['name']);

    return (package != null)
        ? new PackageResource(package..addAll(packageConfig))
        : null;
  }

  Future<dynamic> _callApi(String packageName) async {
    Uri url = Uri.parse('${_host}/${_uri}/${packageName}');
    Response response = await get(url);

    return (response.statusCode == 200) ? JSON.decode(response.body) : null;
  }
}
