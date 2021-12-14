import 'package:flutter/material.dart';
import 'package:news_app_2/core/app_colors.dart';
import 'package:news_app_2/ui/articles_list_item.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const dummyImagePath =
        'https://academy.binance.com/_next/image?url=https%3A%2F%2Fimage.binance.vision%2Fuploads-original%2F4777d1c2d7b14907a480ea1bb86d8f22.png&w=750&q=80';

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryTags(
                padding: EdgeInsets.zero, articleCategories: ["DeFi", "NFT"]),
            SizedBox(height: 30),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: double.infinity,
                height: 180,
                child: Image.network(
                  dummyImagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(right: 50.0),
              child: Text(
                "What is NFT Staking and How Does it Work?",
                style: TextStyle(fontSize: 25.5, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: 18),
            Row(
              children: [
                DifficultyPill(
                  difficultyLevel: "Beginner",
                  fontSize: 14,
                  dotSize: 7,
                ),
                SizedBox(width: 10),
                Text("Updated Dec 13, 2021",
                    style: TextStyle(color: AppColors.textGrey)),
                SizedBox(width: 10),
                ReadingTime(readingTimeInMins: 5),
                SizedBox(height: 30),
              ],
            )
          ],
        ),
      ),
    );
  }
}
