// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      id: json['id'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      image: json['image'] as String?,
      difficultyLevel: json['difficultyLevel'] as String?,
      readTime: json['readTime'] as int?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date?.toIso8601String(),
      'image': instance.image,
      'difficultyLevel': instance.difficultyLevel,
      'readTime': instance.readTime,
      'categories': instance.categories,
    };
