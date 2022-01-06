// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_preview_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlePreviewBody _$ArticlePreviewBodyFromJson(Map<String, dynamic> json) =>
    ArticlePreviewBody(
      previews: (json['article_previews'] as List<dynamic>?)
          ?.map((e) => ArticlePreview.fromJson(e as Object))
          .toList(),
      grandTotalCount: json['grandTotalCount'] as int?,
    );

Map<String, dynamic> _$ArticlePreviewBodyToJson(ArticlePreviewBody instance) =>
    <String, dynamic>{
      'article_previews': instance.previews,
      'grandTotalCount': instance.grandTotalCount,
    };
