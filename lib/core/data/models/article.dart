import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.image,
    required this.difficultyLevel,
    required this.readTime,
    required this.categories,
  });

  int? id;
  String? title;
  String? content;
  DateTime? date;
  String? image;
  String? difficultyLevel;
  int? readTime;
  List<String>? categories;


  factory Article.fromJson(Object? data) => _$ArticleFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
