import 'package:flutter/material.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/ui/article_filter_screen.dart';
import 'package:news_app_2/ui/articles_list_item.dart';
import 'package:news_app_2/ui/articles_screen.dart';

class ArticlesListView extends StatefulWidget {
  final ArticleFilter? filter;

  const ArticlesListView({Key? key, required this.filter}) : super(key: key);

  @override
  _ArticlesListViewState createState() => _ArticlesListViewState();
}

class _ArticlesListViewState extends State<ArticlesListView> {
  @override
  void initState() {
    // TODO: Fetch articles
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ArticlesListView oldWidget) {
    if (oldWidget.filter != widget.filter) {
      // TODO: Fetch articles

    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12, top: 12, bottom: 6),
          child: Text(
            "Articles (340)",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: 4,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
            itemBuilder: (ctx, idx) {
              return const ArticleListItem();
            },
            separatorBuilder: (ctx, idx) {
              return const SizedBox(height: 10);
            },
          ),
        ),
      ],
    );
  }
}
