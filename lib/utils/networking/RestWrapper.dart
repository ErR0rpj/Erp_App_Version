import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import '../consts.dart';

class RestWrapper {
  Dio _dio = new Dio();

  Future<dynamic> get(String service) async {
    var responseJson;
    try {
      final response = await _dio
          .get(SERVER_URL + service)
          .timeout(Duration(seconds: SERVER_TIMEOUT), onTimeout: () {
        throw Exception(NO_CONNECTION_ERROR);
      });
      responseJson = _processResponse(response);
    } on SocketException {
      throw Exception(NO_CONNECTION_ERROR);
    }
    return responseJson;
  }

  Future<dynamic> post(String service, Map<String, dynamic> data) async {
    var responseJson;
    try {
      final response =
          await _dio.post(SERVER_URL + service, data: json.encode(data));
      responseJson = _processResponse(response);
    } on SocketException {
      throw Exception(NO_CONNECTION_ERROR);
    }
    return responseJson;
  }

  Future<String> jwtOrEmpty() async {
    var storage = FlutterSecureStorage();
    var jwt = await storage.read(key: SECURE_STORAGE_TOKEN_KEY);
    if (jwt == null) return "";
    return jwt;
  }

  Future<void> setToken(String token) async {
    var storage = FlutterSecureStorage();
    await storage.write(key: SECURE_STORAGE_TOKEN_KEY, value: token);
    _dio.options.headers
        .addAll({'x-auth-token': token, 'content-type': HTTP_CONTENT_TYPE});
    return;
  }

  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        //TODO: Make all return type as JSON only
        var responseJson = response.data;
        return responseJson;
      case 400:
        throw Exception(BAD_REQUEST_ERROR);
      case 404:
        throw Exception(NOT_FOUND_ERROR);
      case 500:
        throw Exception(SERVER_INTERNAL_ERROR);
      default:
        throw Exception('${response.statusCode}');
    }
  }
}
