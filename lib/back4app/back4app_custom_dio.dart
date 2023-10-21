import 'package:contact_list_app/back4app/back4app_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Back4AppCustomDio {
  final _dio = Dio();

  Dio get dio => _dio;

  Back4AppCustomDio() {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['X-Parse-Application-Id'] = dotenv.env['BACK4APP_APPLICATION_ID'];
    _dio.options.headers['X-Parse-REST-API-Key'] = dotenv.env['BACK4APP_REST_API_KEY'];
    _dio.options.baseUrl = dotenv.env['BACK4APP_BASE_URL']!;
    _dio.interceptors.add(Back4AppDioInterceptor());
  }
}