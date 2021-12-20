import 'package:flutter/material.dart';
import 'package:news_app_2/app/article_home/screens/articles_home_screen.dart';
import 'package:news_app_2/app/article_home/view_models/article_home_view_model.dart';
import 'package:news_app_2/core/app_routes.dart';
import 'package:news_app_2/core/app_theme.dart';
import 'package:news_app_2/core/service_module.dart';
import 'package:provider/provider.dart';

void main() async {
  ServiceModule.inject();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArticleHomeViewModel())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().lightTheme,
        home: const ArticlesScreen(),
        onGenerateRoute: AppRoutes.generateRouteWithSettings,
        routes: AppRoutes.buildRouteMap());
  }
}
