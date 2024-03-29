import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/core/app_routes.dart';

import 'package:news_app_2/core/data/models/article_preview.dart';
import 'package:news_app_2/core/ui/color_utils.dart';
import 'package:news_app_2/core/ui/styles/app_colors.dart';
import 'package:news_app_2/core/ui/widgets/state_indicators.dart';
import 'package:news_app_2/core/utils/date_utils.dart';

import 'package:news_app_2/core/utils/string_util.dart';


class ArticleListItem extends StatelessWidget {
  const ArticleListItem({Key? key, required this.preview}) : super(key: key);

  final ArticlePreview preview;

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.articleDetails,
            arguments: preview.id);
      },
      child: Container(
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildImage(imageUrl: preview.image ?? ''),
                CategoryTags(
                  articleCategories: preview.categories ?? [],
                )
              ],
            ),
            const SizedBox(height: 10),
            _buildTitle(title: preview.title ?? ""),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                children: [
                  DifficultyPill(
                    difficultyLevel: preview.difficultyLevel ?? "",
                  ),
                  const SizedBox(width: 13),
                  Text(
                    DateUtil.getFormattedDate(preview.date),
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                  const SizedBox(width: 13),
                  ReadingTimeLabel(readingTimeInMins: preview.readTime ?? 0)
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImage({required String imageUrl}) {
    imageUrl = StringUtil.getUrlForRunPlatform(imageUrl);

    // log("image url : $imageUrl");

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: CachedNetworkImage(
          imageUrl: StringUtil.getUrlForRunPlatform(imageUrl),
          placeholder: (context, url) => const PageLoadingIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ReadingTimeLabel extends StatelessWidget {
  final int readingTimeInMins;

  const ReadingTimeLabel({Key? key, required this.readingTimeInMins})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.schedule,
          color: AppColors.textGrey,
          size: 15,
        ),
        SizedBox(width: 3),
        Text(
          "${readingTimeInMins}m",
          style: TextStyle(color: AppColors.textGrey),
        ),
      ],
    );
  }
}

class DifficultyPill extends StatelessWidget {
  final String difficultyLevel;
  final double? fontSize;
  final double? dotSize;

  const DifficultyPill(
      {Key? key, required this.difficultyLevel, this.fontSize, this.dotSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: getColor(difficultyLevel).withOpacity(0.23),
      ),
      child: Row(
        children: [
          Container(
            height: dotSize ?? 5,
            width: dotSize ?? 5,
            decoration: BoxDecoration(
              color: getColor(difficultyLevel),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            difficultyLevel,
            style: TextStyle(
                color: Colors.black.withOpacity(0.7), fontSize: fontSize ?? 11),
          )
        ],
      ),
    );
  }
}

class CategoryTags extends StatelessWidget {
  final List<String> articleCategories;
  final EdgeInsets? padding;

  const CategoryTags({Key? key, required this.articleCategories, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (articleCategories.isEmpty) {
      return const SizedBox();
    }

    var tags = <String>[];
    if (articleCategories.length <= 2) {
      tags.addAll(articleCategories);
    } else {
      tags = articleCategories.take(2).toList();
      tags.add("+${articleCategories.length - 2}");
    }

    return Padding(
      padding: padding ?? EdgeInsets.only(left: 18.0, top: 20.0),
      child: Wrap(
        spacing: 8.0,
        children: tags.map((e) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              e,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// class ArticlePreview {
// final int id;
//   final String title;
//   final String difficultyLevel;
//   final int readingTime;
//   final List<Strings> categories
// final DateTime dateCreated
// }

// class Article {
// final int id;
//   final String title;
//   final String content;
//   final String difficultyLevel;
//   final int readingTime;
//   final List<Strings> categories
// final DateTime dateCreated
// }
