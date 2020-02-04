import 'package:cloud_functions/cloud_functions.dart';

abstract class BaseMCloudFunctions {
  HttpsCallable getcallable(String functionName);

  Future<HttpsCallableResult> callFunction(HttpsCallable callable,
      {Map<String, dynamic> param});
}

class MCloudFunctions extends BaseMCloudFunctions {
  HttpsCallable getcallable(String functionName) {
    return CloudFunctions.instance.getHttpsCallable(
      functionName: functionName,
    );
  }

  Future<HttpsCallableResult> callFunction(HttpsCallable callable,
      {Map<String, dynamic> param}) async {
    return await callable.call(param);
  }
}

HttpsCallable getcallable(String functionName) {
  return CloudFunctions.instance.getHttpsCallable(
    functionName: functionName,
  );
}

Future<HttpsCallableResult> callFunction(HttpsCallable callable,
    {Map<String, dynamic> param}) async {
  return await callable.call(param);
}
