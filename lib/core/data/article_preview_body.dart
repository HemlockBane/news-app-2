import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:news_app_2/core/data/article_preview.dart';

part 'article_preview_body.g.dart';

@JsonSerializable()
class ArticlePreviewBody {
  ArticlePreviewBody({required this.previews, required this.grandTotalCount});
  @JsonKey(name: "article_previews")
  List<ArticlePreview>? previews;
  int? grandTotalCount;

  factory ArticlePreviewBody.fromJson(Object? data) =>
      _$ArticlePreviewBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ArticlePreviewBodyToJson(this);

  bool shouldFetchMore(int previouslyFetchedItemsCount) {
    log("previouslyFetchedItemsCount: $previouslyFetchedItemsCount");
    log("newItemsCount: ${(grandTotalCount ?? 0)}");

    final newItemsCount = grandTotalCount ?? 0;
    final totalFetchedItemsCount = previouslyFetchedItemsCount + newItemsCount;
    final shouldFetchMore = totalFetchedItemsCount < (grandTotalCount ?? 0);

    log("should fetch more: $shouldFetchMore");

    return shouldFetchMore;
  }
}
