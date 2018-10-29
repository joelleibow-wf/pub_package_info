import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

class PubApi {
  final String _host = 'https://pub.dartlang.org';
  final String _uri = 'api/packages';

  Future<dynamic> getPackageInfo(String packageName) async {
    return await _callApi(packageName);
  }

  Future<dynamic> _callApi(String packageName) async {
    Uri url = Uri.parse('${_host}/${_uri}/${packageName}');
    Response response = await get(url);

    return (response.statusCode == 200) ? JSON.decode(response.body) : null;
  }
}
