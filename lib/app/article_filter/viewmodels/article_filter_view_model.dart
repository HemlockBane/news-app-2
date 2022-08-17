import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_2/core/data/delegates/article_service_delegate.dart';
import 'package:news_app_2/core/data/models/filter_options.dart';
import 'package:news_app_2/core/data/models/resource.dart';

class ArticleFilterViewModel with ChangeNotifier {
  late final ArticleServiceDelegate _articleServiceDelegate;

  ArticleFilterViewModel({ArticleServiceDelegate? articleServiceDelegate})
      : _articleServiceDelegate =
            articleServiceDelegate ?? GetIt.I<ArticleServiceDelegate>();

  final StreamController<Resource<FilterOptions>> _filterOptionsController =
      StreamController.broadcast();

  Stream<Resource<FilterOptions>> get filterOptionsStream =>
      _filterOptionsController.stream;


  Future<void> getFilterOptions() async {
    _filterOptionsController.sink.add(Resource.loading(null));

    final res = await _articleServiceDelegate.getFilterOptions();
    _filterOptionsController.sink.add(res);
  }

  @override
  void dispose() {
    _filterOptionsController.close();
    super.dispose();
  }
}
