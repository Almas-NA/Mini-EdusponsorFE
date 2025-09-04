import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';

//* Request methods which needs access token have to be passed
//* with "X-Auth-AccessToken" header as accesstoken.
class AuthorizationInterceptor extends Interceptor {
  Box box = Hive.box('eduSponsor');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra['requiresToken'] ?? false) {
      String? accessToken = box.get('accesstoken');
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      accessToken == null
          ? Get.toNamed('/login')
          : 
          options.headers.addAll(headers);
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.headers['accesstoken'] != null) {
      box.put('accesstoken', response.headers['accesstoken']?[0]);
    }
    return super.onResponse(response, handler);
  }
}
