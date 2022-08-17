// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterOptions _$FilterOptionsFromJson(Map<String, dynamic> json) =>
    FilterOptions(
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Object))
          .toList(),
      difficultyLevels: (json['difficultyLevels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FilterOptionsToJson(FilterOptions instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'difficultyLevels': instance.difficultyLevels,
    };
