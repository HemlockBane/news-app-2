import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/app/article_details/viewmodels/article_details_view_model.dart';
import 'package:news_app_2/app/article_home/widgets/articles_list_item.dart';
import 'package:news_app_2/core/app_colors.dart';
import 'package:news_app_2/core/data/article.dart';
import 'package:news_app_2/core/date_utils.dart';
import 'package:news_app_2/core/resource.dart';
import 'package:news_app_2/core/string_util.dart';
import 'package:news_app_2/core/widgets/state_indicators.dart';
import 'package:provider/provider.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({Key? key, required this.articleId})
      : super(key: key);

  final int? articleId;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late ArticleDetailsViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<ArticleDetailsViewModel>(context, listen: false);
    viewModel.getArticleDetails(widget.articleId ?? 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const dummyImagePath =
        'https://academy.binance.com/_next/image?url=https%3A%2F%2Fimage.binance.vision%2Fuploads-original%2F4777d1c2d7b14907a480ea1bb86d8f22.png&w=750&q=80';

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: viewModel.articleStream,
            builder: (context, AsyncSnapshot<Resource<Article>> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data is Loading ||
                  snapshot.data is Error ||
                  snapshot.data?.data == null) {
                return Container();
              }

              final article = snapshot.data?.data;

              return Text(article?.title ?? "");
            }),
      ),
      body: StreamBuilder(
          stream: viewModel.articleStream,
          builder: (context, AsyncSnapshot<Resource<Article>> snapshot) {
            if (!snapshot.hasData || snapshot.data is Loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }

            if (snapshot.data is Error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Oops! Could not fetch article details."),
                    const SizedBox(height: 8),
                    TextButton(
                      child: const Text("Retry",
                          style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        viewModel.getArticleDetails(widget.articleId ?? 0);
                      },
                    )
                  ],
                ),
              );
            }

            final article = snapshot.data?.data;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryTags(
                      padding: EdgeInsets.zero,
                      articleCategories: article?.categories ?? []),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      child: CachedNetworkImage(
                        imageUrl: StringUtil.getUrlForRunPlatform(article?.image ?? ''),
                        placeholder: (context, url) => const PageLoadingIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(right: 50.0),
                    child: Text(
                      article?.title ?? "",
                      style: const TextStyle(
                          fontSize: 25.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      DifficultyPill(
                        difficultyLevel: article?.difficultyLevel ?? "",
                        fontSize: 14,
                        dotSize: 7,
                      ),
                      const SizedBox(width: 10),
                      Text(DateUtil.getFormattedDate(article?.date),
                          style: const TextStyle(color: AppColors.textGrey)),
                      const SizedBox(width: 10),
                      ReadingTimeLabel(
                          readingTimeInMins: article?.readTime ?? 0),
                      const SizedBox(height: 30),
                    ],
                  ),
                  const SizedBox(height: 19),
                  Text(
                    StringUtil.getSanitizedContent(article?.content ?? ""),
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            );
          }),
    );
  }
}
