import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/app/article_filter/viewmodels/article_filter_view_model.dart';
import 'package:news_app_2/app/article_filter/widgets/category_filter_group.dart';
import 'package:news_app_2/app/article_filter/widgets/difficulty_level_filter_group.dart';
import 'package:news_app_2/app/article_filter/widgets/reading_time_filter_group.dart';
import 'package:news_app_2/app/article_home/widgets/articles_list_view.dart';
import 'package:news_app_2/core/filter_options.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/core/resource.dart';
import 'package:provider/provider.dart';

class ArticleFilterScreen extends StatefulWidget {
  final ArticleFilter? filter;
  const ArticleFilterScreen({Key? key, required this.filter}) : super(key: key);

  @override
  _ArticleFilterScreenState createState() => _ArticleFilterScreenState();
}

class _ArticleFilterScreenState extends State<ArticleFilterScreen> {
  // List<String> _allCategories = [];
  // List<String> _allDifficultyLevels = [];

  late final ArticleFilterViewModel _filterViewModel;

  List<String> _selectedCategories = [];
  List<String> _selectedDifficultyLevels = [];
  ReadingTimeRange _selectedReadingTimeRange =
      const ReadingTimeRange(min: 0, max: 30);

  ArticleFilter? get _previousFilter => widget.filter;

  List<String> get _previouslySelectedCategories =>
      _previousFilter?.categories ?? [];
  List<String> get _previouslySelectedDifficultyLevels =>
      _previousFilter?.difficultyLevels ?? [];
  ReadingTimeRange get _previouslySelectedReadingTimeRange =>
      _previousFilter?.readingTimeRange ??
      const ReadingTimeRange(min: 0, max: 30);

  bool get _hasUpdatedCategories =>
      !listEquals(_previouslySelectedCategories, _selectedCategories);
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
      _selectedCategories = List.of(_previousFilter!.categories);
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
                return ErrorStateWidget(
                  errorMessage:
                      "We could not fetch the filter options. Please check your internet connection and try again",
                  onError: () {
                    _filterViewModel.getFilterOptions();
                  },
                );
              }

              if (snapshot.data?.data == null) {
                return ErrorStateWidget(
                  errorMessage:
                      "We could not fetch the filter options. Please contact the support team",
                  onError: () {
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
                        selectedCategories: _selectedCategories,
                        onCategoryTap: (FilterItem item) {
                          setState(() {
                            _selectedCategories.addOrRemoveItem(item.name);
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
      categories: _selectedCategories,
      difficultyLevels: _selectedDifficultyLevels,
      readingTimeRange: _selectedReadingTimeRange,
    );
    Navigator.of(context).pop(filter);
  }

  void _clearFilter() {
    setState(() {
      _selectedCategories.clear();
      _selectedDifficultyLevels.clear();
      final timeRange = _previouslySelectedReadingTimeRange;
      _selectedReadingTimeRange = const ReadingTimeRange(min: 0, max: 30);
    });
  }
}

extension _Toggle<T> on List<T> {
  void addOrRemoveItem(T item) => contains(item) ? remove(item) : add(item);
}
