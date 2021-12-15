import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/ui/screens/article_details_screen.dart';
import 'package:news_app_2/ui/screens/article_filter_screen.dart';

class AppRoutes {
  static const articlesHome = "articlesHome";
  static const articleDetails = "articleDetails";
  static const articleFilter = "articleFilter";

  static Map<String, WidgetBuilder> buildRouteMap() {
    return {
      AppRoutes.articleDetails: (BuildContext ctx) => ArticleDetailScreen()
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
    }
  }
}
