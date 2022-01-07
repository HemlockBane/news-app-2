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
  static const _device = "device";
  static const _emulator = "emulator";

  static const _emulatorIPV4 = "10.0.2.2";
  static const _physicalDeviceIPV4 = "192.168.43.116";

  static const _config = _device;
  static const String ipv4 =
      (_config == _emulator) ? _emulatorIPV4 : _physicalDeviceIPV4;
}

const localHost = "http://${UrlConfig.ipv4}/newsapp/wp-json/api";

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
