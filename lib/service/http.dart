import 'package:dio/dio.dart';

class HttpService {
  static BaseOptions _options =
      BaseOptions(baseUrl: 'https://en.wikipedia.org/api/rest_v1/page/mobile-html/');
  static Dio dio = new Dio(_options)..interceptors.add(RequestInterceptor());
  Future<Response> get(String path) {
    return dio.get(path);
  }
}

class RequestInterceptor extends Interceptor {
  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) async {
    await _handleResponse(err.response);
    return super.onError(err);
  }

  Future _handleResponse(Response response) async {
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(
            message: 'Bad Request ', code: response.statusCode);
      case 404:
        throw NotFoundException(
            message: 'Url not found', code: response.statusCode);
    }
  }
}

class CustomAppException implements Exception {
  final String message;
  final int code;

  CustomAppException({this.message, this.code});
}

class BadRequestException extends CustomAppException {
  BadRequestException({String message, int code})
      : super(message: message, code: code);
}

class NotFoundException extends CustomAppException {
  NotFoundException({String message, int code})
      : super(message: message, code: code);
}
