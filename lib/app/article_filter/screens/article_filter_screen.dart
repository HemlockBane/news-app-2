import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/app/article_filter/viewmodels/article_filter_view_model.dart';
import 'package:news_app_2/app/article_filter/widgets/category_filter_group.dart';
import 'package:news_app_2/app/article_filter/widgets/difficulty_level_filter_group.dart';
import 'package:news_app_2/app/article_filter/widgets/reading_time_filter_group.dart';
import 'package:news_app_2/core/data/models/article_filter.dart';
import 'package:news_app_2/core/data/models/resource.dart';
import 'package:news_app_2/core/ui/widgets/state_indicators.dart';
import 'package:provider/provider.dart';

import '../../../core/data/models/filter_options.dart';

class ArticleFilterScreen extends StatefulWidget {
  final ArticleFilter? filter;
  const ArticleFilterScreen({Key? key, required this.filter}) : super(key: key);

  @override
  _ArticleFilterScreenState createState() => _ArticleFilterScreenState();
}

class _ArticleFilterScreenState extends State<ArticleFilterScreen> {

  late final ArticleFilterViewModel _filterViewModel;

  List<int> _selectedCategoryIds = [];
  List<String> _selectedDifficultyLevels = [];
  ReadingTimeRange _selectedReadingTimeRange =
      const ReadingTimeRange(min: 0, max: 30);

  ArticleFilter? get _previousFilter => widget.filter;

  List<int> get _previouslySelectedCategoryIds =>
      _previousFilter?.categoryIds ?? [];
  List<String> get _previouslySelectedDifficultyLevels =>
      _previousFilter?.difficultyLevels ?? [];
  ReadingTimeRange get _previouslySelectedReadingTimeRange =>
      _previousFilter?.readingTimeRange ??
      const ReadingTimeRange(min: 0, max: 30);

  bool get _hasUpdatedCategories =>
      !listEquals(_previouslySelectedCategoryIds, _selectedCategoryIds);
  bool get _hasUpdatedDifficultyLevels => !listEquals(
      _previouslySelectedDifficultyLevels, _selectedDifficultyLevels);
  bool get _hasUpdatedReadingTime =>
      _previouslySelectedReadingTimeRange != _selectedReadingTimeRange;

  bool get _hasUpdatedFilter =>
      _hasUpdatedCategories ||
      _hasUpdatedDifficultyLevels ||
      _hasUpdatedReadingTime;

  @override
  void initState() {
    if (_previousFilter != null) {
      _selectedCategoryIds = List.of(_previousFilter!.categoryIds);
      _selectedDifficultyLevels = List.of(_previousFilter!.difficultyLevels);
      _selectedReadingTimeRange = _previousFilter!.readingTimeRange;
    }
    _filterViewModel =
        Provider.of<ArticleFilterViewModel>(context, listen: false);
    _filterViewModel.getFilterOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _hasUpdatedFilter
              ? TextButton(
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    minimumSize: MaterialStateProperty.all(Size.zero),
                  ),
                  onPressed: () {
                    _applyFilter(context);
                  },
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 12),
          TextButton(
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all(Size.zero),
            ),
            onPressed: () {
              _clearFilter();
            },
            child: const Text(
              "Clear",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: StreamBuilder(
            stream: _filterViewModel.filterOptionsStream,
            builder:
                (context, AsyncSnapshot<Resource<FilterOptions>> snapshot) {
              if (!snapshot.hasData || snapshot.data is Loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }

              if (snapshot.data is Error) {
                return PageBanner(
                  message:
                      "We could not fetch the filter options. Please check your internet connection and try again",
                  onRetry: () {
                    _filterViewModel.getFilterOptions();
                  },
                );
              }

              if (snapshot.data?.data == null) {
                return PageBanner(
                  message:
                      "We could not fetch the filter options. Please contact the support team",
                  onRetry: () {
                    _filterViewModel.getFilterOptions();
                  },
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    ReadingTimeFilterGroup(
                      timeRange: _selectedReadingTimeRange,
                      onReadingTimeChanged: (readingTime) {
                        setState(() {
                          _selectedReadingTimeRange = readingTime;
                        });
                      },
                    ),
                    const SizedBox(height: 35),
                    ArticleDifficultyLevelGroup(
                      allLevels: snapshot.data?.data?.difficultyLevels ?? [],
                      selectedLevels: _selectedDifficultyLevels,
                      onLevelTap: (FilterItem item) {
                        setState(() {
                          _selectedDifficultyLevels.addOrRemoveItem(item.name);
                        });
                      },
                    ),
                    const SizedBox(height: 35),
                    CategoryFilterGroup(
                        allCategories: snapshot.data?.data?.categories ?? [],
                        selectedCategoryIds: _selectedCategoryIds,
                        onCategoryTap: (FilterItem item) {
                          setState(() {
                            _selectedCategoryIds.addOrRemoveItem(item.id!);
                          });
                        }),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void _applyFilter(BuildContext context) {
    final filter = ArticleFilter(
      categoryIds: _selectedCategoryIds,
      difficultyLevels: _selectedDifficultyLevels,
      readingTimeRange: _selectedReadingTimeRange,
    );
    Navigator.of(context).pop(filter);
  }

  void _clearFilter() {
    setState(() {
      _selectedCategoryIds.clear();
      _selectedDifficultyLevels.clear();
      final timeRange = _previouslySelectedReadingTimeRange;
      _selectedReadingTimeRange = const ReadingTimeRange(min: 0, max: 30);
    });
  }
}

extension _Toggle<T> on List<T> {
  void addOrRemoveItem(T item) => contains(item) ? remove(item) : add(item);
}
