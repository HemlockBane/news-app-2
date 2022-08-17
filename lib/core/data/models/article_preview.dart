import 'package:json_annotation/json_annotation.dart';

part 'article_preview.g.dart';

@JsonSerializable()
class ArticlePreview {
  ArticlePreview({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
    required this.difficultyLevel,
    required this.readTime,
    required this.categories,
  });

  int? id;
  String? title;
  DateTime? date;
  String? image;
  String? difficultyLevel;
  int? readTime;
  List<String>? categories;

   factory ArticlePreview.fromJson(Object? data) => _$ArticlePreviewFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ArticlePreviewToJson(this);
}
