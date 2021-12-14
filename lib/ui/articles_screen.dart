import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/ui/article_filter_screen.dart';
import 'package:news_app_2/ui/articles_list_view.dart';

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
        title: const Text("Jerome Academy"),
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
    final route = MaterialPageRoute(
        builder: (_) => ArticleFilterScreen(
              filter: _filter,
            ),
        fullscreenDialog: true);
    final searchFilter = await Navigator.of(context).push(route);
    if (searchFilter != null) {
      // TODO: Set search filter here
    }
  }
}
