import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode, kReleaseMode
import 'package:frontend/core/common/logger/app_logger.dart';

class DioFactory {
  static Dio createDio({String? baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? "",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      _AppLogInterceptor(),
      _ErrorInterceptor(),
      // You can add RetryInterceptor here if needed
    ]);

    return dio;
  }
}

class _AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.i("➡️ ${options.method} ${options.baseUrl}${options.path}");
      AppLogger.d("Headers: ${options.headers}");
      AppLogger.d("Data: ${options.data}");
    } else {
      // Prod: minimal logs
      AppLogger.i("➡️ ${options.method} ${options.path}");
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.i("✅ ${response.statusCode} ${response.requestOptions.path}");
      AppLogger.d("Response: ${response.data}");
    } else {
      AppLogger.i("✅ ${response.statusCode} ${response.requestOptions.path}");
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.e(
        "❌ ${err.requestOptions.method} ${err.requestOptions.path} | ${err.type} | ${err.message}",
      );
      AppLogger.d("StackTrace: ${err.stackTrace}");
    } else {
      AppLogger.e(
        "❌ ${err.requestOptions.method} ${err.requestOptions.path} | ${err.type}",
      );
    }
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = "Connection timeout. Please try again.";
        break;
      case DioExceptionType.badResponse:
        message = "Server error: ${err.response?.statusCode}";
        break;
      case DioExceptionType.connectionError:
        message = "No internet connection.";
        break;
      default:
        message = "Unexpected error: ${err.message}";
    }

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: message,
      ),
    );
  }
}
