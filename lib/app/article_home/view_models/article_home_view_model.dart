import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_2/core/article_service_delegate.dart';
import 'package:news_app_2/core/data/article_preview_body.dart';
import 'package:news_app_2/core/resource.dart';

class ArticleHomeViewModel with ChangeNotifier {
  late final ArticleServiceDelegate _articleServiceDelegate;

  final StreamController<Resource<ArticlePage>> _articlePreviewController =
      StreamController.broadcast();

  Stream<Resource<ArticlePage>> get articlePreviewStream =>
      _articlePreviewController.stream;

  ArticleHomeViewModel({ArticleServiceDelegate? articleServiceDelegate})
      : _articleServiceDelegate =
            articleServiceDelegate ?? GetIt.I<ArticleServiceDelegate>();

  void getArticlePreview(int page, Map<String, dynamic> body) async {
    _articlePreviewController.sink.add(Resource.loading(null));

    final res = await _articleServiceDelegate.getArticlePreview(page, body);
    _articlePreviewController.sink.add(res);
  }

  @override
  void dispose() {
    _articlePreviewController.close();
    super.dispose();
  }
}
