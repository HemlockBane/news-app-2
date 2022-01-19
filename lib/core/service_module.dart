import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_2/core/article_service.dart';
import 'package:news_app_2/core/article_service_delegate.dart';
import 'package:news_app_2/core/data/article_preview.dart';
import 'package:news_app_2/core/interceptors/logging_interceptor.dart';
import 'package:news_app_2/core/interceptors/mock_service_interceptor.dart';

class ServiceModule {
  static Dio getConfiguredApiClient() {
    final dioOptions = BaseOptions(
      connectTimeout: 60000,
      receiveTimeout: 60000 * 2,
      sendTimeout: 60000,
    );
    final dio = Dio(dioOptions)
      ..interceptors.addAll([
        LoggingInterceptor(),
        MockArticlePreviewInterceptor(),
        MockArticleRequestInterceptor(),
        MockFilterRequestInterceptor()
      ]);
    return dio;
  }

  static void inject() {
    final dio = getConfiguredApiClient();
    GetIt.I.registerLazySingleton<ArticleServiceDelegate>(() {
      return ArticleServiceDelegate(ArticleService(dio));
    });
  }
}
