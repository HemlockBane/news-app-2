import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:news_app_2/core/data/data_sources/cache.dart';
import 'package:news_app_2/core/data/models/article.dart';
import 'package:news_app_2/core/data/models/articles_preview_response.dart';
import 'package:news_app_2/core/data/models/filter_options.dart';
import 'package:news_app_2/core/data/models/resource.dart';


import '../data_sources/article_service.dart';

class ArticleServiceDelegate {
  late final ArticleService _service;

  ArticleServiceDelegate(ArticleService service) {
    _service = service;
  }

  Future<Resource<ArticlePage>> getArticlePreview(int page,
      Map<String, dynamic> body) async {
    try {
      log(body.toString(), name: "filter body");
      final response = await _service.getAllArticles(page, body);

      if (page == 1) {
        log("cache before fetch:");
        getFilterOptions();
      }
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

  Future<Resource<FilterOptions>> getFilterOptions() async {
    try {
      final cache = Cache();
      if (!cache.isEmpty()) {
        final categories = await cache.getCategories();
        final diffLevels = await cache.getDifficultyLevels();
        final filterOptions =
            FilterOptions(categories: categories, difficultyLevels: diffLevels);
        return Resource.success(filterOptions);
      }

      final response = await _service.getArticleFilterOptions();
      final categories = response.filterOptions?.categories;
      final difficultyLevels = response.filterOptions?.difficultyLevels;

      await cache.saveCategories(categories ?? []);
      await cache.saveDifficultyLevels(difficultyLevels ?? []);

      cache.printAll();

      return Resource.success(response.filterOptions);
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

// Once we get all the articles, get all the filter options categories and difficulty levels
// Store them in a local cache

// In the filter screen, get all filter options


