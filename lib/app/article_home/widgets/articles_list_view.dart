import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news_app_2/app/article_home/view_models/article_home_view_model.dart';
import 'package:news_app_2/app/article_home/widgets/articles_list_item.dart';
import 'package:news_app_2/core/article_service_delegate.dart';
import 'package:news_app_2/core/data/article_preview.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/core/resource.dart';
import 'package:news_app_2/core/widgets/state_indicators.dart';

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
      Map<String, dynamic> body = _getFilterBody();
      widget.viewModel.getArticlePreview(pageKey, body);
    });

    previewSubscription = widget.viewModel.articlePreviewStream.listen((event) {
      _onPageFetched(event);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ArticlesListView oldWidget) {
    if (oldWidget.filter != widget.filter) {
      log("filter updated: ${widget.filter}");
      _pagingController.refresh();
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
                  return const PageLoadingIndicator();
                },
                firstPageProgressIndicatorBuilder: (context) {
                  return const PageLoadingIndicator();
                },
                firstPageErrorIndicatorBuilder: (context) => Center(
                  child: ErrorPageBanner(
                    error: _pagingController.error,
                    onRetry: () {
                      _pagingController.retryLastFailedRequest();
                    },
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) {
                  return EmptyListPageBanner(onRetry: () {
                    _pagingController.retryLastFailedRequest();
                  });
                },
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

  Map<String, dynamic> _getFilterBody() {
    final filter = widget.filter;
    var body = <String, dynamic>{};

    if (filter == null) {
      body["read_time"] = [1, 60];
    } else {
      final readTimeRange = filter.readingTimeRange;
      final minReadTime = readTimeRange.min == 0 ? 1 : readTimeRange.min;
      final maxReadTime = readTimeRange.max >= 30 ? 60 : readTimeRange.max;

      body["read_time"] = [minReadTime, maxReadTime];

      if (filter.categoryIds.isNotEmpty) {
        body["category"] = filter.categoryIds;
      }

      if (filter.difficultyLevels.isNotEmpty) {
        body["difficulty_level"] = filter.difficultyLevels;
      }
    }
    return body;
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
}

class PageLoadingIndicator extends StatelessWidget {
  const PageLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    Key? key,
    required this.onError,
    this.errorMessage =
        "Oops! Something went wrong. Please check your internet connection and try again",
  }) : super(key: key);

  final VoidCallback onError;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorMessage),
        const SizedBox(height: 8),
        TextButton(
          child: const Text("Retry", style: TextStyle(color: Colors.black)),
          onPressed: () {
            onError.call();
          },
        )
      ],
    );
  }
}
