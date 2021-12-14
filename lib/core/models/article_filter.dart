class FilterItem {
  final String name;
  final bool isSelected;

  FilterItem({required this.name, required this.isSelected});
}

class ArticleFilter {
  final List<String> categories;
  final List<String> difficultyLevels;

  ArticleFilter({required this.categories, required this.difficultyLevels});
}
