import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_2/core/article_service.dart';
import 'package:news_app_2/core/article_service_delegate.dart';
import 'package:news_app_2/core/data/article_preview.dart';

class ServiceModule {
  static Dio getConfiguredApiClient() {
    final dioOptions = BaseOptions(
      connectTimeout: 60000,
      receiveTimeout: 60000 * 2,
      sendTimeout: 60000,
    );
    final dio = Dio(dioOptions)..interceptors.addAll([LoggingInterceptor()]);
    return dio;
  }

  static void inject() {
    final dio = getConfiguredApiClient();
      GetIt.I.registerLazySingleton<ArticleServiceDelegate>(() {
        return ArticleServiceDelegate(ArticleService(dio));
      });


    
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logPrint('*** API Request - Start ***');

    printKV('URI', options.uri);
    printKV('METHOD', options.method);
    logPrint('HEADERS:');
    options.headers.forEach((key, v) => printKV(' - $key', v));
    logPrint('BODY:');
    printAll(options.data ?? "");
    if (options.data is FormData) {
      final data = options.data as FormData;
      logPrint('BOUNDARY:${data.boundary}');
      logPrint('FILES:');
      data.files.forEach((element) {
        print(element.key);
        print("--->>>");
        print(element.value.length);
        print(element.value.contentType);
        print(element.value.filename);
      });
      // data.fields.forEach((element) {
      //
      // });
      logPrint('FIELDS:');
      printAll(data.fields);
    }

    logPrint('*** API Request - End ***');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logPrint('*** Api Response - Start ***');

    printKV('URI', response.requestOptions.uri);
    printKV('STATUS CODE', response.statusCode ?? "");
    printKV('REDIRECT', response.isRedirect ?? "");
    logPrint('BODY:');
    printAll(response.data ?? "");

    logPrint('*** Api Response - End ***');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logPrint('*** Api Error - Start ***:');

    logPrint('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      logPrint('STATUS CODE: ${err.response?.statusCode?.toString()}');
    }
    logPrint('$err');
    if (err.response != null) {
      printKV('REDIRECT', err.response?.realUri ?? "");
      logPrint('BODY:');
      printAll(err.response?.toString());
    }

    logPrint('*** Api Error - End ***:');
    return super.onError(err, handler);
  }

  void printKV(String key, Object? v) {
    logPrint('$key: $v');
  }

  void printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }

  void logPrint(String s) {
    debugPrint(s);
  }
}
