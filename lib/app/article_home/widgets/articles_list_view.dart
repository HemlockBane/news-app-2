import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news_app_2/app/article_home/view_models/article_home_view_model.dart';
import 'package:news_app_2/app/article_home/widgets/articles_list_item.dart';
import 'package:news_app_2/core/article_service_delegate.dart';
import 'package:news_app_2/core/data/article_preview.dart';
import 'package:news_app_2/core/data/article_preview_body.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/core/resource.dart';

class ArticlesListView extends StatefulWidget {
  final ArticleFilter? filter;
  final ArticleHomeViewModel viewModel;

  const ArticlesListView(
      {Key? key, required this.filter, required this.viewModel})
      : super(key: key);

  @override
  _ArticlesListViewState createState() => _ArticlesListViewState();
}

class _ArticlesListViewState extends State<ArticlesListView> {
  final PagingController<int, ArticlePreview> _pagingController =
      PagingController(firstPageKey: 1);

  late final StreamSubscription<Resource<ArticlePage>> previewSubscription;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      final queries = {"page": pageKey};
      widget.viewModel.getArticlePreview(queries);
    });

    previewSubscription = widget.viewModel.articlePreviewStream.listen((event) {
      _onPageFetched(event);
    });
    super.initState();
  }

  void _onPageFetched(Resource<ArticlePage> event) {
    if (event is Success && event.data != null) {
      final newPage = event.data!;

      final newItems = newPage.response.articlePreviewBody.previews!;

      final previouslyFetchedItemsCount =
          _pagingController.itemList?.length ?? 0;

      final shouldFetchMore = newPage.response.articlePreviewBody
          .shouldFetchMore(previouslyFetchedItemsCount);

      if (shouldFetchMore) {
        final nextPageKey = newPage.page + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      } else {
        _pagingController.appendLastPage(newItems);
      }
    }

    if (event is Error) {
      _pagingController.error = event;
    }
  }

  @override
  void didUpdateWidget(covariant ArticlesListView oldWidget) {
    if (oldWidget.filter != widget.filter) {
      // TODO: Fetch articles

    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    previewSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 12, bottom: 6),
          child: StreamBuilder(
              stream: widget.viewModel.articlePreviewStream,
              builder:
                  (context, AsyncSnapshot<Resource<ArticlePage>> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data is Loading ||
                    snapshot.data is Error) {
                  return Container();
                }

                if (snapshot.data?.data?.response == null) {
                  return Container();
                }

                final count = snapshot.data!.data!.response.articlePreviewBody
                        .grandTotalCount ??
                    0;

                return Text(
                  count > 0 ? "Articles ($count)" : '',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
        ),
        Expanded(
          child: RefreshIndicator(
            color: Colors.black,
            onRefresh: () => Future.sync(() => _pagingController.refresh()),
            child: PagedListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<ArticlePreview>(
                itemBuilder: (context, preview, index) =>
                    ArticleListItem(preview: preview),
                newPageProgressIndicatorBuilder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                },
                firstPageProgressIndicatorBuilder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Oops! Could not fetch articles..."),
                      const SizedBox(height: 8),
                      TextButton(
                        child: const Text("Retry",
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          _pagingController.refresh();
                        },
                      )
                    ],
                  ),
                ),
              ),
              separatorBuilder: (ctx, idx) {
                return const SizedBox(height: 10);
              },
            ),
          ),
        ),
      ],
    );
  }
}
