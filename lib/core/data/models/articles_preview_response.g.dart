// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articles_preview_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlesPreviewResponse _$ArticlesPreviewResponseFromJson(
        Map<String, dynamic> json) =>
    ArticlesPreviewResponse(
      articlePreviewBody:
          ArticlePreviewBody.fromJson(json['article_preview_body'] as Object),
    );

Map<String, dynamic> _$ArticlesPreviewResponseToJson(
        ArticlesPreviewResponse instance) =>
    <String, dynamic>{
      'article_preview_body': instance.articlePreviewBody,
    };
