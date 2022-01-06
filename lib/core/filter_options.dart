import 'package:json_annotation/json_annotation.dart';

part 'filter_options.g.dart';

@JsonSerializable()
class FilterOptions {
  FilterOptions({
    required this.categories,
    required this.difficultyLevels,
  });

  List<String>? categories;
  List<String>? difficultyLevels;


  factory FilterOptions.fromJson(Object? data) =>
      _$FilterOptionsFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FilterOptionsToJson(this);


  
}
