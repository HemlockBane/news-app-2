import 'package:dio/dio.dart';
import 'package:news_app_2/core/data/article.dart';
import 'package:news_app_2/core/data/article_preview.dart';
import 'package:news_app_2/core/data/article_preview_body.dart';
import 'package:news_app_2/core/data/article_response.dart';
import 'package:news_app_2/core/filter_options_response.dart';
import 'package:retrofit/retrofit.dart';

import 'data/articles_preview_response.dart';

part 'article_service.g.dart';

const localHost = "http://10.0.2.2/newsapp/wp-json/api";

@RestApi(baseUrl: "$localHost/")
abstract class ArticleService {
  factory ArticleService(Dio dio) = _ArticleService;

  @GET("/articles_preview")
  Future<ArticlesPreviewResponse> getAllArticles(
      @Queries() Map<String, dynamic> queries);

  @GET("/article_by_id")
  Future<ArticleResponse> getArticleById(@Query("id") int id);

  @GET("/article_filter_options")
  Future<FilterOptionsResponse> getArticleFilterOptions();

}



