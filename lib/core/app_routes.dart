import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/app/article_details/screens/article_details_screen.dart';
import 'package:news_app_2/app/article_details/viewmodels/article_details_view_model.dart';
import 'package:news_app_2/app/article_filter/screens/article_filter_screen.dart';
import 'package:news_app_2/core/data/models/article_filter.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static const articlesHome = "articlesHome";
  static const articleDetails = "articleDetails";
  static const articleFilter = "articleFilter";

  static Map<String, WidgetBuilder> buildRouteMap() {
    return {
      // AppRoutes.articleDetails: (BuildContext ctx) => ArticleDetailScreen()
    };
  }

  static MaterialPageRoute? generateRouteWithSettings(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.articleFilter:
        final filter = settings.arguments as ArticleFilter?;

        return MaterialPageRoute<ArticleFilter>(
          builder: (ctx) => ArticleFilterScreen(filter: filter),
          fullscreenDialog: true,
        );

      case AppRoutes.articleDetails:
        final articleId = settings.arguments as int?;
        return MaterialPageRoute<ArticleFilter>(
          builder: (ctx) => ChangeNotifierProvider(
              create: (_) => ArticleDetailsViewModel(),
              child: ArticleDetailScreen(articleId: articleId ?? 0)),
        );
    }
  }
}
