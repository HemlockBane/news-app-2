import 'package:dio/dio.dart';
import 'package:news_app_2/core/data/article.dart';
import 'package:news_app_2/core/data/article_preview.dart';
import 'package:news_app_2/core/data/article_preview_body.dart';
import 'package:news_app_2/core/data/article_response.dart';
import 'package:news_app_2/core/filter_options_response.dart';
import 'package:retrofit/retrofit.dart';

import 'data/articles_preview_response.dart';

part 'article_service.g.dart';

class UrlConfig {
  static const _phone = "phone";
  static const _emulator = "emulator";
  static const _devDeviceConfig = _phone;

  static const _devHostForEmulator = "10.0.2.2/wordpress";
  static const _devHostForPhone = "192.168.43.116/wordpress";
  static const _liveHost = "192.248.153.131";

  static const _live = "live";
  static const _dev = "dev";
  static const _serverConfig = _live;

  static const String host = _serverConfig == _live
      ? _liveHost
      : (_devDeviceConfig == _emulator)
          ? _devHostForEmulator
          : _devHostForPhone;
}

const localHost = "http://${UrlConfig.host}/wp-json/api";

@RestApi(baseUrl: "$localHost/")
abstract class ArticleService {
  factory ArticleService(Dio dio) = _ArticleService;

  @POST("/articles_preview")
  Future<ArticlesPreviewResponse> getAllArticles(
      @Query("page") int page, @Body() Map<String, dynamic> body);

  @GET("/article_by_id")
  Future<ArticleResponse> getArticleById(@Query("id") int id);

  @GET("/article_filter_options")
  Future<FilterOptionsResponse> getArticleFilterOptions();
}



class MockArticleService implements ArticleService{
  @override
  Future<ArticlesPreviewResponse> getAllArticles(int page, Map<String, dynamic> body) {
    // TODO: implement getAllArticles
    throw UnimplementedError();
  }

  @override
  Future<ArticleResponse> getArticleById(int id) {
    // TODO: implement getArticleById
    throw UnimplementedError();
  }

  @override
  Future<FilterOptionsResponse> getArticleFilterOptions() {
    // TODO: implement getArticleFilterOptions
    throw UnimplementedError();
  }

}
