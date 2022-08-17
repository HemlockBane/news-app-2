import 'package:json_annotation/json_annotation.dart';
import 'package:news_app_2/core/data/models/category.dart';

part 'filter_options.g.dart';

@JsonSerializable()
class FilterOptions {
  FilterOptions({
    required this.categories,
    required this.difficultyLevels,
  });

  List<Category>? categories;
  List<String>? difficultyLevels;


  factory FilterOptions.fromJson(Object? data) =>
      _$FilterOptionsFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FilterOptionsToJson(this);


  
}
