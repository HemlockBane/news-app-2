import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/core/app_colors.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/ui/category_filter_group.dart';
import 'package:news_app_2/ui/difficulty_level_filter_group.dart';

class ArticleFilterScreen extends StatefulWidget {
  final ArticleFilter? filter;
  const ArticleFilterScreen({Key? key, required this.filter}) : super(key: key);

  @override
  _ArticleFilterScreenState createState() => _ArticleFilterScreenState();
}

class _ArticleFilterScreenState extends State<ArticleFilterScreen> {
  List<String> _allCategories = ["Altcoin", "Binance", "Bitcoin"];
  List<String> _allDifficultyLevels = ["Beginner", "Intermediate", "Advanced"];

  List<String> _selectedCategories = [];
  List<String> _selectedDifficultyLevels = [];

  ArticleFilter? get _previousFilter => widget.filter;

  List<String> get _previouslySelectedCategories =>
      _previousFilter?.categories ?? [];
  List<String> get _previouslySelectedDifficultyLevels =>
      _previousFilter?.difficultyLevels ?? [];

  bool get _hasUpdatedCategories =>
      !listEquals(_previouslySelectedCategories, _selectedCategories);
  bool get _hasUpdatedDifficultyLevels => !listEquals(
      _previouslySelectedDifficultyLevels, _selectedDifficultyLevels);

  bool get _hasUpdatedFilter =>
      _hasUpdatedCategories || _hasUpdatedDifficultyLevels;

  @override
  void initState() {
    if (_previousFilter != null) {
      _selectedCategories = List.of(_previousFilter!.categories);
      _selectedDifficultyLevels = List.of(_previousFilter!.difficultyLevels);
    }
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              ReadingTimeFilterGroup(),
              const SizedBox(height: 25),
              ArticleDifficultyLevelGroup(
                allLevels: _allDifficultyLevels,
                selectedLevels: _selectedDifficultyLevels,
                onLevelTap: (FilterItem item) {
                  setState(() {
                    _selectedDifficultyLevels.addOrRemoveItem(item.name);
                  });
                },
              ),
              const SizedBox(height: 25),
              CategoryFilterGroup(
                  allCategories: _allCategories,
                  selectedCategories: _selectedCategories,
                  onCategoryTap: (FilterItem item) {
                    setState(() {
                      _selectedCategories.addOrRemoveItem(item.name);
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _applyFilter(BuildContext context) {
    final filter =
        ArticleFilter(categories: _selectedCategories, difficultyLevels: []);
    Navigator.of(context).pop(filter);
  }

  void _clearFilter() {
    setState(() {
      _selectedCategories.clear();
      _selectedDifficultyLevels.clear();
    });
  }
}

extension _Toggle<T> on List<T> {
  void addOrRemoveItem(T item) => contains(item) ? remove(item) : add(item);
}

class ReadingTimeFilterGroup extends StatefulWidget {
  const ReadingTimeFilterGroup({Key? key}) : super(key: key);

  @override
  State<ReadingTimeFilterGroup> createState() => _ReadingTimeFilterGroupState();
}

class _ReadingTimeFilterGroupState extends State<ReadingTimeFilterGroup> {
  var rangeValue = RangeValues(0.2, 0.8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reading Time",
          style: TextStyle(fontSize: 15.5),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            thumbColor: Colors.white,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.black.withOpacity(0.1),
            overlayColor: AppColors.intermediateDarkYellow.withOpacity(0.2),
            activeTickMarkColor: Colors.red,
            inactiveTickMarkColor: Colors.black.withOpacity(0.1),
            trackHeight: 8
          ),
          child: RangeSlider(
            values: rangeValue,
            onChanged: (RangeValues value) {
              setState(() {
                rangeValue = value;
              });

              print(rangeValue);
            },
            divisions: 10,
          ),
        )
      ],
    );
  }
}
