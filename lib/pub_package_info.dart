library pub_package_info;

import './src/pub_api.dart';

getPackageInfo(String packageName) async {
  PubApi pubApi = new PubApi();

  return await pubApi.getPackageInfo(packageName);
}
