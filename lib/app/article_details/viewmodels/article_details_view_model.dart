import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../../core/data/delegates/article_service_delegate.dart';
import '../../../core/data/models/article.dart';
import '../../../core/data/models/resource.dart';

class ArticleDetailsViewModel with ChangeNotifier {
  late final ArticleServiceDelegate _articleServiceDelegate;

  final StreamController<Resource<Article>> _articleController =
      StreamController.broadcast();

  Stream<Resource<Article>> get articleStream => _articleController.stream;

  ArticleDetailsViewModel({ArticleServiceDelegate? articleServiceDelegate})
      : _articleServiceDelegate =
            articleServiceDelegate ?? GetIt.I<ArticleServiceDelegate>();

  void getArticleDetails(int id) async {
    _articleController.sink.add(Resource.loading(null));

    final res = await _articleServiceDelegate.getArticleDetails(id);
    _articleController.sink.add(res);
  }

  @override
  void dispose() {
    _articleController.close();
    super.dispose();
  }
}
