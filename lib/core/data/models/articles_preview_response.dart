

import 'package:json_annotation/json_annotation.dart';
import 'package:news_app_2/core/data/models/article_preview_body.dart';


part 'articles_preview_response.g.dart';


@JsonSerializable()
class ArticlesPreviewResponse{
  ArticlesPreviewResponse({
    required this.articlePreviewBody
  });

  @JsonKey(name: "article_preview_body")
  ArticlePreviewBody articlePreviewBody;

  factory ArticlesPreviewResponse.fromJson(Object? data) => _$ArticlesPreviewResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ArticlesPreviewResponseToJson(this);
}
