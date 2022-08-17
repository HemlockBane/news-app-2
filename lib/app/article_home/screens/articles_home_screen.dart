import 'package:flutter/material.dart';
import 'package:news_app_2/app/article_home/view_models/article_home_view_model.dart';
import 'package:news_app_2/app/article_home/widgets/articles_list_view.dart';
import 'package:news_app_2/core/app_routes.dart';
import 'package:news_app_2/core/data/models/article_filter.dart';
import 'package:provider/provider.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  ArticleFilter? _filter;
  late final ArticleHomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<ArticleHomeViewModel>(context, listen: false);
    super.initState();
  }

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
        viewModel: _viewModel,
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
    setState(() {
      if (searchFilter != null) {
        _filter = searchFilter;
      }
    });
  }
}
