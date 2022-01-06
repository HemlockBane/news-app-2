import 'package:json_annotation/json_annotation.dart';
import 'article.dart';

part 'article_response.g.dart';


@JsonSerializable()
class ArticleResponse {
  ArticleResponse({
    this.article,
  });

  Article? article;

  factory ArticleResponse.fromJson(Object? data) => _$ArticleResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ArticleResponseToJson(this);
}