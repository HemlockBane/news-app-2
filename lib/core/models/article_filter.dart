import 'package:news_app_2/app/article_filter/widgets/reading_time_filter_group.dart';

class FilterItem {
  final String name;
  final bool isSelected;

  FilterItem({required this.name, required this.isSelected});
}

class ArticleFilter {
  final List<String> categories;
  final List<String> difficultyLevels;
  final ReadingTimeRange readingTimeRange;

  ArticleFilter(
      {required this.categories,
      required this.difficultyLevels,
      required this.readingTimeRange});
}
