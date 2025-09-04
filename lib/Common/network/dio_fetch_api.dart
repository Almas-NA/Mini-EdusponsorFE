import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_client.dart';
import 'package:edusponsor/Common/network/dio_exception.dart';
import 'package:edusponsor/Common/snack_bar_service.dart';
import 'package:edusponsor/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData;

class FetchApi {
  factory FetchApi() {
    return _singleton;
  }

  FetchApi._internal();

  static final FetchApi _singleton = FetchApi._internal();

  static Future<dynamic> getData({
    required String endPoint,
    Map<String, String>? headers,
    bool requiresToken = true,
  }) async {
    try {
      final response = await DioClient.client.get(endPoint,
          options: Options(
            headers: headers,
            extra: {'requiresToken': requiresToken},
          ));

      return decodeResponse(response.data);
    } on DioException catch (err) {
      CustomDioException.fromDioError(err).toString();
    } on Exception catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static Future<dynamic> postData({
    required String endPoint,
    Map? body,
    Map<String, String>? headers,
    bool requiresToken = true,
  }) async {
    try {
      final response = await DioClient.client.post(
        endPoint,
        options: Options(
          headers: headers,
          extra: {'requiresToken': requiresToken},
          validateStatus: (_) => true,
        ),
        data: jsonEncode(body),
      );

      return decodeResponse(response.data);
    } on DioException catch (err) {
      CustomDioException.fromDioError(err).toString();
    } on Exception catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  static dynamic decodeResponse(dynamic response) {
    try {
      final dynamic resultJson;
      // some times response may be json
      if (!(response.runtimeType == String)) {
        final result = jsonEncode(response);
        resultJson = jsonDecode(result);
      } else {
        resultJson = jsonDecode(response);
      }

      if (SnackBarService.checkResponseType(resultJson)) {
        List message=resultJson['responseData']['message'];
        if (message.isNotEmpty) {
          SnackBarService.showSnackBar(
              message[0], resultJson['type']);
        }
        if ((resultJson['redirect'] ?? false) &&
            resultJson['type'] == ServerResponseType.ERROR.name) {
          Get.offAll(const LoginPage());
        }
      }
      return resultJson;
    } on Exception catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static Future<dynamic> postFormData({
    required String endPoint,
    required FormData formData,
    Map<String, String>? headers,
    bool requiresToken = true,
  }) async {
    try {
      final response = await DioClient.client.post(
        endPoint,
        options: Options(
          headers: headers,
          contentType: 'multipart/form-data',
          extra: {'requiresToken': requiresToken},
        ),
        data: formData,
      );

      return decodeResponse(response.data);
    } on DioException catch (err) {
      CustomDioException.fromDioError(err).toString();
    } on Exception catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  static Future<Uint8List?> fetchImageAsBlob1({
    required String endPoint,
    Map? body,
    bool requiresToken = true,
  }) async {
    try {
      final response = await DioClient.client.post(
        endPoint,
        data: jsonEncode(body),
        options: Options(
          responseType: ResponseType.bytes,
          contentType: 'image/jpg',
          extra: {'requiresToken': requiresToken},
        ),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;

        if (responseData is Uint8List) {
          return responseData;
        } else if (responseData is String) {
          return Uint8List.fromList(responseData.codeUnits);
        } else {
          throw Exception('Unexpected response type');
        }
      }
    } on DioException catch (err) {
      CustomDioException.fromDioError(err).toString();
    } on Exception catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
    return null;
  }
}
