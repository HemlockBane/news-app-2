import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/core/app_routes.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/ui/screens/article_filter_screen.dart';
import 'package:news_app_2/ui/widgets/articles_list_view.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  ArticleFilter? _filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.92),
      appBar: AppBar(
        title: const Text("Articles"),
        actions: [
          TextButton(
              child: const Text(
                "Show filters",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _navigateToFilterScreen(context);
              })
        ],
      ),
      body: ArticlesListView(
        filter: _filter,
      ),
    );
  }

  Future _navigateToFilterScreen(BuildContext context) async {
    final searchFilter = await Navigator.pushNamed<ArticleFilter>(
      context,
      AppRoutes.articleFilter,
      arguments: _filter,
    );
    if (searchFilter != null) {
      _filter = searchFilter;
    }
  }
}
