import 'package:equatable/equatable.dart';
import 'package:news_app_2/app/article_filter/widgets/reading_time_filter_group.dart';

class FilterItem extends Equatable {
  final int? id;
  final String name;
  final bool isSelected;

  const FilterItem({
    this.id,
    required this.name,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [id, name, isSelected];

  @override
  bool? get stringify => true;
}

class ArticleFilter extends Equatable {
  final List<int> categoryIds;
  final List<String> difficultyLevels;
  final ReadingTimeRange readingTimeRange;

  const ArticleFilter(
      {required this.categoryIds,
      required this.difficultyLevels,
      required this.readingTimeRange});

  @override
  List<Object?> get props => [categoryIds, difficultyLevels, readingTimeRange];

  @override
  bool? get stringify => true;
}
