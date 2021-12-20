import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:news_app_2/core/article_service.dart';
import 'package:news_app_2/core/data/article.dart';
import 'package:news_app_2/core/data/article_preview.dart';
import 'package:news_app_2/core/data/article_preview_body.dart';
import 'package:news_app_2/core/resource.dart';

import 'data/articles_preview_response.dart';

class ArticleServiceDelegate {
  late final ArticleService _service;

  ArticleServiceDelegate(ArticleService service) {
    _service = service;
  }

  Future<Resource<ArticlePage>> getArticlePreview(
      Map<String, dynamic> queries) async {
    try {
      final response = await _service.getAllArticles(queries);
      final page = queries["page"];
      return Resource.success(ArticlePage(page: page, response: response));
    } catch (error) {
      log(error.toString());
      if (error is DioError && error.error is SocketException) {
        return Resource.error(errorMessage: error.message);
      }

      return Resource.error(errorMessage: error.toString());
    }
  }

  Future<Resource<Article>> getArticleDetails(int id) async {
    try {
      final response = await _service.getArticleById(id);
      return Resource.success(response.article);
    } catch (error) {
      log(error.toString());
      if (error is DioError && error.error is SocketException) {
        return Resource.error(errorMessage: error.message);
      }

      return Resource.error(errorMessage: error.toString());
    }
  }
}

class ArticlePage {
  ArticlesPreviewResponse response;
  int page;

  ArticlePage({required this.page, required this.response});
}
